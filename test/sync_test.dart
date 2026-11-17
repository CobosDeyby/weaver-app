import 'dart:convert';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weaver_app/api/api.dart';
import 'package:weaver_app/data/database.dart';
import 'package:weaver_app/sync/sync_service.dart';

import 'support.dart';

void main() {
  late AppDatabase db;
  late FakeApi api;
  late SyncService sync;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    api = FakeApi();
    sync = SyncService(db, api, 7);
  });

  tearDown(() => db.close());

  Future<void> addResponse(String id, {int userId = 7, DateTime? finishedAt, bool located = true}) => db
      .into(db.responses)
      .insert(
        ResponsesCompanion.insert(
          id: id,
          userId: userId,
          surveyId: 1,
          surveyTitle: 'Hogares',
          version: 1,
          answers: jsonEncode({'tiene_ninos': 'no'}),
          startedAt: DateTime.utc(2026, 11, 16, 19),
          finishedAt: finishedAt ?? DateTime.utc(2026, 11, 16, 19, 5),
          latitude: Value(located ? 4.6 : null),
          longitude: Value(located ? -74.08 : null),
          accuracy: Value(located ? 12 : null),
        ),
      );

  Future<String> statusOf(String id) async =>
      (await (db.select(db.responses)..where((row) => row.id.equals(id))).getSingle()).status;

  test('downloads surveys and only re-downloads the ones that changed', () async {
    api
      ..addSurvey(1, 'h1')
      ..addSurvey(2, 'h2', title: 'Otra');

    await sync.run();
    expect((await db.select(db.surveys).get()).map((s) => s.title), unorderedEquals(['Hogares', 'Otra']));

    api.calls.clear();
    api.addSurvey(2, 'h2-new', title: 'Otra', version: 2);
    final report = await sync.run();

    expect(report.surveysUpdated, 1);
    expect(api.calls.where((call) => call.startsWith('definition')), ['definition:2']);
    expect((await (db.select(db.surveys)..where((s) => s.id.equals(2))).getSingle()).version, 2);
  });

  test('removes surveys that are no longer assigned', () async {
    api.addSurvey(1, 'h1');
    await sync.run();

    api.remoteSurveys.clear();
    await sync.run();

    expect(await db.select(db.surveys).get(), isEmpty);
  });

  test('downloads lists with their items in order', () async {
    api
      ..addCatalog(1, 'c1', [
        {'value': 'ant', 'label': 'Antioquia', 'parent': null},
        {'value': 'cun', 'label': 'Cundinamarca', 'parent': null},
      ])
      ..addCatalog(2, 'c2', [
        {'value': 'bog', 'label': 'Bogotá', 'parent': 'cun'},
      ], parentId: 1);

    await sync.run();

    expect((await db.itemsOf(1)).map((item) => item.label), ['Antioquia', 'Cundinamarca']);
    expect((await db.itemsOf(2)).single.parent, 'cun');

    // A changed list replaces its items; an unchanged one is not fetched again.
    api.calls.clear();
    api.addCatalog(1, 'c1-new', [
      {'value': 'ant', 'label': 'Antioquia', 'parent': null},
    ]);
    await sync.run();

    expect(api.calls.where((call) => call.startsWith('catalog:')), ['catalog:1']);
    expect((await db.itemsOf(1)).length, 1);
  });

  test('sends pending responses with the fields the server expects', () async {
    await addResponse('11111111-1111-4111-8111-111111111111');
    await addResponse('22222222-2222-4222-8222-222222222222', located: false);

    final report = await sync.run();

    expect(report.sent, 2);
    expect(api.received.first, {
      'id': '11111111-1111-4111-8111-111111111111',
      'survey_id': 1,
      'version': 1,
      'answers': {'tiene_ninos': 'no'},
      'started_at': '2026-11-16T19:00:00.000Z',
      'finished_at': '2026-11-16T19:05:00.000Z',
      'location': {'lat': 4.6, 'lng': -74.08, 'accuracy': 12.0},
    });
    expect(api.received.last.containsKey('location'), isFalse);
    expect(await statusOf('11111111-1111-4111-8111-111111111111'), 'synced');
    expect(await db.pendingResponses(7, 50), isEmpty);
  });

  test('without network everything stays pending and nothing is lost', () async {
    await addResponse('11111111-1111-4111-8111-111111111111');
    api.offline = true;

    await expectLater(sync.run(), throwsA(isA<ApiException>()));
    expect(await statusOf('11111111-1111-4111-8111-111111111111'), 'pending');

    api.offline = false;
    await sync.run();
    expect(await statusOf('11111111-1111-4111-8111-111111111111'), 'synced');
  });

  test('a response the server already has counts as sent', () async {
    await addResponse('11111111-1111-4111-8111-111111111111');
    api.received.add({'id': '11111111-1111-4111-8111-111111111111'});

    final report = await sync.run();

    expect(report.sent, 1);
    expect(api.received.length, 1);
  });

  test('rejected responses keep the reason and are not retried', () async {
    await addResponse('11111111-1111-4111-8111-111111111111');
    api.rejectReasons['11111111-1111-4111-8111-111111111111'] = 'not_assigned';

    final report = await sync.run();
    final stored = await db.select(db.responses).getSingle();

    expect(report.rejected, 1);
    expect(stored.status, 'rejected');
    expect(stored.reason, 'not_assigned');

    api.calls.clear();
    await sync.run();
    expect(api.calls.where((call) => call.startsWith('batch')), isEmpty);
  });

  test('more than one batch is sent in order, 50 at a time', () async {
    for (var i = 0; i < 120; i++) {
      await addResponse(
        '00000000-0000-4000-8000-${'$i'.padLeft(12, '0')}',
        finishedAt: DateTime.utc(2026, 11, 16, 12).add(Duration(minutes: i)),
      );
    }

    await sync.run();

    expect(api.calls.where((call) => call.startsWith('batch')), ['batch:50', 'batch:50', 'batch:20']);
    expect(api.received.first['id'], '00000000-0000-4000-8000-000000000000');
  });

  test('responses of another person on the same phone are not sent', () async {
    await addResponse('11111111-1111-4111-8111-111111111111', userId: 99);

    await sync.run();

    expect(api.received, isEmpty);
    expect(await statusOf('11111111-1111-4111-8111-111111111111'), 'pending');
  });
}
