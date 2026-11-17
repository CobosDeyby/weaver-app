import 'package:dio/dio.dart';

/// A failure the person can do something about, already worded for them.
class ApiException implements Exception {
  ApiException(this.message, {this.fields = const {}, this.unauthorized = false});

  final String message;

  /// Validation errors by field (`email`, `code`…).
  final Map<String, String> fields;

  /// The token is no longer valid: the person must sign in again.
  final bool unauthorized;

  @override
  String toString() => message;
}

class LoginResult {
  LoginResult({required this.token, required this.userId, required this.userName});

  final String token;
  final int userId;
  final String userName;
}

class RemoteSurvey {
  RemoteSurvey(Map<String, dynamic> json)
    : id = json['id'] as int,
      title = json['title'] as String,
      description = json['description'] as String?,
      organization = (json['organization'] as Map)['name'] as String,
      version = json['version'] as int,
      hash = json['hash'] as String;

  final int id;
  final String title;
  final String? description;
  final String organization;
  final int version;
  final String hash;
}

class RemoteCatalog {
  RemoteCatalog(Map<String, dynamic> json)
    : id = json['id'] as int,
      name = json['name'] as String,
      parentId = json['parent_id'] as int?,
      hash = json['hash'] as String,
      items = [
        for (final item in (json['items'] as List? ?? const [])) Map<String, dynamic>.from(item as Map),
      ];

  final int id;
  final String name;
  final int? parentId;
  final String hash;

  /// `{value, label, parent}`; empty in the list endpoint.
  final List<Map<String, dynamic>> items;
}

class BatchResult {
  BatchResult(Map<String, dynamic> json)
    : id = json['id'] as String?,
      status = json['status'] as String,
      reason = json['reason'] as String?;

  final String? id;

  /// accepted | duplicate | rejected
  final String status;
  final String? reason;
}

/// What the app needs from the server. Tests replace it with a fake.
abstract class WeaverApi {
  Future<List<RemoteSurvey>> surveys();

  /// The published definition of one survey, as a JSON map.
  Future<Map<String, dynamic>> definition(int surveyId);

  Future<List<RemoteCatalog>> catalogs();
  Future<RemoteCatalog> catalog(int id);
  Future<List<BatchResult>> sendResponses(List<Map<String, dynamic>> responses);
  Future<void> logout();
}

class HttpWeaverApi implements WeaverApi {
  HttpWeaverApi(String baseUrl, {String? token})
    : _dio = Dio(
        BaseOptions(
          baseUrl: '${baseUrl.replaceAll(RegExp(r'/+$'), '')}/api/v2',
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 60),
          headers: {'Accept': 'application/json', if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );

  final Dio _dio;

  Future<LoginResult> login({
    required String email,
    required String password,
    String? code,
    required Map<String, String?> device,
  }) async {
    final data = await _send(
      () => _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
          if (code != null && code.isNotEmpty) 'code': code,
          'device': device,
        },
      ),
    );
    final user = data['user'] as Map;

    return LoginResult(
      token: data['token'] as String,
      userId: user['id'] as int,
      userName: user['name'] as String,
    );
  }

  @override
  Future<void> logout() async {
    await _send(() => _dio.post<dynamic>('/auth/logout'));
  }

  @override
  Future<List<RemoteSurvey>> surveys() async {
    final data = await _send(() => _dio.get<Map<String, dynamic>>('/surveys'));

    return [for (final item in data['data'] as List) RemoteSurvey(Map<String, dynamic>.from(item as Map))];
  }

  @override
  Future<Map<String, dynamic>> definition(int surveyId) async {
    final data = await _send(() => _dio.get<Map<String, dynamic>>('/surveys/$surveyId'));

    return Map<String, dynamic>.from((data['data'] as Map)['definition'] as Map);
  }

  @override
  Future<List<RemoteCatalog>> catalogs() async {
    final data = await _send(() => _dio.get<Map<String, dynamic>>('/catalogs'));

    return [for (final item in data['data'] as List) RemoteCatalog(Map<String, dynamic>.from(item as Map))];
  }

  @override
  Future<RemoteCatalog> catalog(int id) async {
    final data = await _send(() => _dio.get<Map<String, dynamic>>('/catalogs/$id'));

    return RemoteCatalog(Map<String, dynamic>.from(data['data'] as Map));
  }

  @override
  Future<List<BatchResult>> sendResponses(List<Map<String, dynamic>> responses) async {
    final data = await _send(
      () => _dio.post<Map<String, dynamic>>('/responses/batch', data: {'responses': responses}),
    );

    return [for (final item in data['results'] as List) BatchResult(Map<String, dynamic>.from(item as Map))];
  }

  Future<Map<String, dynamic>> _send(Future<Response<dynamic>> Function() request) async {
    try {
      final response = await request();
      final data = response.data;

      return data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{};
    } on DioException catch (error) {
      throw _translate(error);
    }
  }

  ApiException _translate(DioException error) {
    final response = error.response;

    if (response == null) {
      return ApiException('No hay conexión con el servidor.');
    }

    final body = response.data is Map ? response.data as Map : const {};
    final fields = <String, String>{
      if (body['errors'] is Map)
        for (final entry in (body['errors'] as Map).entries)
          if (entry.value is List && (entry.value as List).isNotEmpty)
            '${entry.key}': '${(entry.value as List).first}',
    };

    return switch (response.statusCode) {
      401 => ApiException('La sesión venció. Entra de nuevo.', unauthorized: true),
      422 => ApiException(fields.values.firstOrNull ?? 'Revisa los datos.', fields: fields),
      429 => ApiException('Demasiados intentos. Espera un minuto.'),
      _ => ApiException(
        '${body['message'] ?? 'El servidor respondió con un error (${response.statusCode}).'}',
      ),
    };
  }
}
