import 'package:drift/drift.dart';

part 'database.g.dart';

/// Published surveys assigned to the signed-in person.
class Surveys extends Table {
  IntColumn get id => integer()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get organization => text()();
  IntColumn get version => integer()();
  TextColumn get hash => text()();

  /// The definition exactly as the server sent it (JSON).
  TextColumn get definition => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Shared option lists used by the surveys on this phone.
class Catalogs extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  IntColumn get parentId => integer().nullable()();
  TextColumn get hash => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@TableIndex(name: 'catalog_items_catalog', columns: {#catalogId, #parent})
class CatalogItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get catalogId => integer()();
  TextColumn get value => text()();
  TextColumn get label => text()();
  TextColumn get parent => text().nullable()();
  IntColumn get position => integer()();
}

/// Completed surveys. They are written here first, always, and leave for the
/// server later; the id is generated on the phone so a retry never duplicates.
class Responses extends Table {
  TextColumn get id => text()();
  IntColumn get userId => integer()();
  IntColumn get surveyId => integer()();
  TextColumn get surveyTitle => text()();
  IntColumn get version => integer()();
  TextColumn get answers => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get finishedAt => dateTime()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  RealColumn get accuracy => real().nullable()();

  /// pending | synced | rejected
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get reason => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Surveys, Catalogs, CatalogItems, Responses])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  Stream<List<Survey>> watchSurveys() =>
      (select(surveys)..orderBy([(survey) => OrderingTerm(expression: survey.title)])).watch();

  Stream<int> watchPendingCount(int userId) {
    final count = responses.id.count();
    final query = selectOnly(responses)
      ..addColumns([count])
      ..where(responses.userId.equals(userId) & responses.status.equals('pending'));

    return query.map((row) => row.read(count) ?? 0).watchSingle();
  }

  Stream<List<Response>> watchResponses(int userId) =>
      (select(responses)
            ..where((response) => response.userId.equals(userId))
            ..orderBy([(response) => OrderingTerm.desc(response.finishedAt)])
            ..limit(200))
          .watch();

  Future<List<Response>> pendingResponses(int userId, int limit) =>
      (select(responses)
            ..where((response) => response.userId.equals(userId) & response.status.equals('pending'))
            ..orderBy([(response) => OrderingTerm(expression: response.finishedAt)])
            ..limit(limit))
          .get();

  Future<List<CatalogItem>> itemsOf(int catalogId) =>
      (select(catalogItems)
            ..where((item) => item.catalogId.equals(catalogId))
            ..orderBy([(item) => OrderingTerm(expression: item.position)]))
          .get();

  Future<void> replaceCatalog(CatalogsCompanion catalog, List<CatalogItemsCompanion> items) =>
      transaction(() async {
        await into(catalogs).insertOnConflictUpdate(catalog);
        await (delete(catalogItems)..where((item) => item.catalogId.equals(catalog.id.value))).go();
        await batch((batch) => batch.insertAll(catalogItems, items));
      });

  /// Forget what was downloaded for the previous person. Their responses stay:
  /// anything still pending is sent when they sign in again.
  Future<void> clearDownloads() => transaction(() async {
    await delete(surveys).go();
    await delete(catalogs).go();
    await delete(catalogItems).go();
  });
}
