import 'dart:convert';

import 'package:weaver_app/api/api.dart';
import 'package:weaver_app/app/location.dart';

/// Department → municipality, a conditional question and a bounded number.
final sampleDefinition = <String, dynamic>{
  'schemaVersion': 2,
  'title': 'Hogares',
  'settings': {'requireLocation': true, 'minDurationSeconds': 0},
  'sections': [
    {
      'key': 's1',
      'title': 'Hogar',
      'questions': [
        {
          'key': 'tiene_ninos',
          'type': 'single_choice',
          'label': '¿Hay menores en el hogar?',
          'required': true,
          'options': [
            {'value': 'si', 'label': 'Sí'},
            {'value': 'no', 'label': 'No'},
          ],
        },
        {
          'key': 'num_ninos',
          'type': 'integer',
          'label': '¿Cuántos?',
          'required': true,
          'validation': {'min': 1, 'max': 20},
          'visibleIf': {'q': 'tiene_ninos', 'op': 'eq', 'value': 'si'},
        },
        {
          'key': 'depto',
          'type': 'single_choice',
          'label': 'Departamento',
          'remember': true,
          'source': {'catalog': 1},
        },
        {
          'key': 'muni',
          'type': 'single_choice',
          'label': 'Municipio',
          'remember': true,
          'source': {'catalog': 2, 'filterBy': 'depto'},
        },
        {'key': 'correo', 'type': 'email', 'label': 'Correo', 'required': false},
        {'key': 'firma', 'type': 'signature', 'label': 'Firma de autorización', 'required': false},
      ],
    },
  ],
};

class FakeLocation implements LocationService {
  FakeLocation([this.fix]);

  final Fix? fix;

  @override
  Future<Fix?> current() async => fix;
}

/// An in-memory server: enough to exercise the sync from both sides.
class FakeApi implements WeaverApi {
  final remoteSurveys = <Map<String, dynamic>>[];
  final remoteCatalogs = <Map<String, dynamic>>[];
  final received = <Map<String, dynamic>>[];
  final rejectReasons = <String, String>{};
  final calls = <String>[];
  bool offline = false;

  void addSurvey(int id, String hash, {String title = 'Hogares', int version = 1}) {
    remoteSurveys
      ..removeWhere((survey) => survey['id'] == id)
      ..add({
        'id': id,
        'title': title,
        'description': null,
        'organization': {'id': 1, 'name': 'Demo'},
        'version': version,
        'hash': hash,
      });
  }

  void addCatalog(int id, String hash, List<Map<String, dynamic>> items, {int? parentId}) {
    remoteCatalogs
      ..removeWhere((catalog) => catalog['id'] == id)
      ..add({'id': id, 'name': 'Lista $id', 'parent_id': parentId, 'hash': hash, 'items': items});
  }

  void _online(String call) {
    calls.add(call);
    if (offline) {
      throw ApiException('No hay conexión con el servidor.');
    }
  }

  @override
  Future<List<RemoteSurvey>> surveys() async {
    _online('surveys');
    return remoteSurveys.map(RemoteSurvey.new).toList();
  }

  @override
  Future<Map<String, dynamic>> definition(int surveyId) async {
    _online('definition:$surveyId');
    return jsonDecode(jsonEncode(sampleDefinition)) as Map<String, dynamic>;
  }

  @override
  Future<List<RemoteCatalog>> catalogs() async {
    _online('catalogs');
    return [
      for (final catalog in remoteCatalogs) RemoteCatalog({...catalog, 'items': const <dynamic>[]}),
    ];
  }

  @override
  Future<RemoteCatalog> catalog(int id) async {
    _online('catalog:$id');
    return RemoteCatalog(remoteCatalogs.firstWhere((catalog) => catalog['id'] == id));
  }

  @override
  Future<List<BatchResult>> sendResponses(List<Map<String, dynamic>> responses) async {
    _online('batch:${responses.length}');

    return [
      for (final response in responses)
        if (rejectReasons.containsKey(response['id']))
          BatchResult({'id': response['id'], 'status': 'rejected', 'reason': rejectReasons[response['id']]})
        else if (received.any((stored) => stored['id'] == response['id']))
          BatchResult({'id': response['id'], 'status': 'duplicate'})
        else
          (() {
            received.add(response);
            return BatchResult({'id': response['id'], 'status': 'accepted'});
          })(),
    ];
  }

  @override
  Future<void> logout() async => _online('logout');
}
