import 'dart:convert';

import 'package:drift/drift.dart';

import '../api/api.dart';
import '../data/database.dart';

class SyncReport {
  int sent = 0;
  int rejected = 0;
  int surveysUpdated = 0;
  int catalogsUpdated = 0;
}

/// Moves data between the phone and the server. Every step is safe to
/// repeat: an interrupted sync just continues next time.
class SyncService {
  SyncService(this._db, this._api, this._userId);

  static const batchSize = 50;

  final AppDatabase _db;
  final WeaverApi _api;
  final int _userId;

  /// Responses go first: field data matters more than fresh definitions.
  Future<SyncReport> run() async {
    final report = SyncReport();

    await uploadPending(report);
    await downloadSurveys(report);
    await downloadCatalogs(report);

    return report;
  }

  Future<void> uploadPending(SyncReport report) async {
    while (true) {
      final pending = await _db.pendingResponses(_userId, batchSize);
      if (pending.isEmpty) {
        return;
      }

      final results = await _api.sendResponses([
        for (final response in pending)
          {
            'id': response.id,
            'survey_id': response.surveyId,
            'version': response.version,
            'answers': jsonDecode(response.answers),
            'started_at': response.startedAt.toUtc().toIso8601String(),
            'finished_at': response.finishedAt.toUtc().toIso8601String(),
            if (response.latitude != null && response.longitude != null)
              'location': {
                'lat': response.latitude,
                'lng': response.longitude,
                'accuracy': response.accuracy,
              },
          },
      ]);

      var settled = 0;

      for (final result in results) {
        if (result.id == null) {
          continue;
        }

        final rejected = result.status == 'rejected';
        settled += await (_db.update(_db.responses)..where((row) => row.id.equals(result.id!))).write(
          ResponsesCompanion(
            status: Value(rejected ? 'rejected' : 'synced'),
            reason: Value(rejected ? result.reason : null),
          ),
        );

        rejected ? report.rejected++ : report.sent++;
      }

      // The server answered but settled nothing: stop instead of looping forever.
      if (settled == 0) {
        return;
      }
    }
  }

  Future<void> downloadSurveys(SyncReport report) async {
    final remote = await _api.surveys();
    final local = {for (final survey in await _db.select(_db.surveys).get()) survey.id: survey};

    for (final survey in remote) {
      if (local[survey.id]?.hash == survey.hash) {
        continue;
      }

      final definition = await _api.definition(survey.id);

      await _db
          .into(_db.surveys)
          .insertOnConflictUpdate(
            SurveysCompanion.insert(
              id: Value(survey.id),
              title: survey.title,
              description: Value(survey.description),
              organization: survey.organization,
              version: survey.version,
              hash: survey.hash,
              definition: jsonEncode(definition),
            ),
          );
      report.surveysUpdated++;
    }

    // No longer assigned, or closed.
    final keep = remote.map((survey) => survey.id).toList();
    await (_db.delete(_db.surveys)..where((row) => row.id.isNotIn(keep))).go();
  }

  Future<void> downloadCatalogs(SyncReport report) async {
    final remote = await _api.catalogs();
    final local = {for (final catalog in await _db.select(_db.catalogs).get()) catalog.id: catalog};

    for (final summary in remote) {
      if (local[summary.id]?.hash == summary.hash) {
        continue;
      }

      final catalog = await _api.catalog(summary.id);

      await _db.replaceCatalog(
        CatalogsCompanion.insert(
          id: Value(catalog.id),
          name: catalog.name,
          parentId: Value(catalog.parentId),
          hash: catalog.hash,
        ),
        [
          for (final (position, item) in catalog.items.indexed)
            CatalogItemsCompanion.insert(
              catalogId: catalog.id,
              value: '${item['value']}',
              label: '${item['label']}',
              parent: Value(item['parent'] as String?),
              position: position,
            ),
        ],
      );
      report.catalogsUpdated++;
    }

    final keep = remote.map((catalog) => catalog.id).toList();
    await (_db.delete(_db.catalogs)..where((row) => row.id.isNotIn(keep))).go();
    await (_db.delete(_db.catalogItems)..where((row) => row.catalogId.isNotIn(keep))).go();
  }
}
