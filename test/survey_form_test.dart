import 'dart:convert';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:weaver_app/app/location.dart';
import 'package:weaver_app/app/session.dart';
import 'package:weaver_app/data/database.dart';
import 'package:weaver_app/ui/survey_form_screen.dart';

import 'support.dart';

void main() {
  late AppDatabase db;
  late FakeApi api;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    api = FakeApi()..addSurvey(1, 'h1');

    await db.replaceCatalog(CatalogsCompanion.insert(id: const Value(1), name: 'Departamentos', hash: 'c1'), [
      CatalogItemsCompanion.insert(catalogId: 1, value: 'ant', label: 'Antioquia', position: 0),
      CatalogItemsCompanion.insert(catalogId: 1, value: 'cun', label: 'Cundinamarca', position: 1),
    ]);
    await db.replaceCatalog(
      CatalogsCompanion.insert(id: const Value(2), name: 'Municipios', parentId: const Value(1), hash: 'c2'),
      [
        CatalogItemsCompanion.insert(
          catalogId: 2,
          value: 'med',
          label: 'Medellín',
          parent: const Value('ant'),
          position: 0,
        ),
        CatalogItemsCompanion.insert(
          catalogId: 2,
          value: 'bog',
          label: 'Bogotá',
          parent: const Value('cun'),
          position: 1,
        ),
      ],
    );
  });

  tearDown(() => db.close());

  Future<void> openForm(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    final survey = Survey(
      id: 1,
      title: 'Hogares',
      organization: 'Demo',
      version: 3,
      hash: 'h1',
      definition: jsonEncode(sampleDefinition),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          storeProvider.overrideWithValue(MemoryStore()),
          initialSessionProvider.overrideWithValue(
            const Session(baseUrl: 'https://example.test', token: 't', userId: 7, userName: 'Ana'),
          ),
          apiProvider.overrideWithValue(api),
          locationProvider.overrideWithValue(FakeLocation(const Fix(4.6, -74.08, 12))),
        ],
        child: MaterialApp(home: SurveyFormScreen(survey: survey)),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('conditional questions appear as the surveyor answers', (tester) async {
    await openForm(tester);

    expect(find.textContaining('¿Cuántos?', findRichText: true), findsNothing);
    expect(find.text('Ubicación obtenida (±12 m)'), findsOneWidget);

    await tester.tap(find.text('Sí'));
    await tester.pumpAndSettle();
    expect(find.textContaining('¿Cuántos?', findRichText: true), findsOneWidget);

    await tester.tap(find.text('No'));
    await tester.pumpAndSettle();
    expect(find.textContaining('¿Cuántos?', findRichText: true), findsNothing);
  });

  testWidgets('saving is blocked until required answers are valid', (tester) async {
    await openForm(tester);

    await tester.tap(find.byKey(const Key('save')));
    await tester.pumpAndSettle();
    expect(find.text('Esta respuesta es obligatoria.'), findsOneWidget);
    expect(await db.select(db.responses).get(), isEmpty);

    await tester.tap(find.text('Sí'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('field-num_ninos')), '40');
    await tester.tap(find.byKey(const Key('save')));
    await tester.pumpAndSettle();

    expect(find.text('El máximo es 20.'), findsOneWidget);
    expect(await db.select(db.responses).get(), isEmpty);
  });

  testWidgets('a dependent list follows its parent, and the response is stored and sent', (tester) async {
    await openForm(tester);

    await tester.tap(find.text('Sí'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('field-num_ninos')), '2');

    expect(find.text('Responde primero la pregunta anterior'), findsOneWidget);

    await tester.tap(find.byKey(const Key('pick-depto')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cundinamarca'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('pick-muni')));
    await tester.pumpAndSettle();
    expect(find.text('Medellín'), findsNothing);
    await tester.tap(find.text('Bogotá'));
    await tester.pumpAndSettle();

    // Changing the department clears the municipality.
    await tester.tap(find.byKey(const Key('pick-depto')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Antioquia'));
    await tester.pumpAndSettle();
    expect(find.text('Bogotá'), findsNothing);

    await tester.tap(find.byKey(const Key('pick-muni')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Medellín'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('save')));
    await tester.pumpAndSettle();

    final stored = await db.select(db.responses).getSingle();
    expect(jsonDecode(stored.answers), {'tiene_ninos': 'si', 'num_ninos': 2, 'depto': 'ant', 'muni': 'med'});
    expect(stored.version, 3);
    expect(stored.userId, 7);
    expect(stored.latitude, 4.6);

    // Saving triggers a sync: the fake server got it and the phone marked it sent.
    expect(api.received.single['id'], stored.id);
    expect(stored.status, anyOf('pending', 'synced'));
    expect((await db.select(db.responses).getSingle()).status, 'synced');
  });
}
