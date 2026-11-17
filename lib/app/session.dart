import 'dart:io' show Platform;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../api/api.dart';
import '../data/database.dart';

const appVersion = '0.1.0';

/// Small persistent key-value store. On the phone it is the secure storage;
/// tests use an in-memory map.
abstract class KeyValueStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

class MemoryStore implements KeyValueStore {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;

  @override
  Future<void> delete(String key) async => values.remove(key);
}

class Session {
  const Session({required this.baseUrl, required this.token, required this.userId, required this.userName});

  final String baseUrl;
  final String token;
  final int userId;
  final String userName;
}

final storeProvider = Provider<KeyValueStore>((ref) => throw UnimplementedError());
final databaseProvider = Provider<AppDatabase>((ref) => throw UnimplementedError());

/// The session restored at startup, read before the first frame.
final initialSessionProvider = Provider<Session?>((ref) => null);

final sessionProvider = NotifierProvider<SessionController, Session?>(SessionController.new);

/// The API of the signed-in person, or null when signed out.
final apiProvider = Provider<WeaverApi?>((ref) {
  final session = ref.watch(sessionProvider);

  return session == null ? null : HttpWeaverApi(session.baseUrl, token: session.token);
});

class SessionController extends Notifier<Session?> {
  @override
  Session? build() => ref.read(initialSessionProvider);

  static Future<Session?> restore(KeyValueStore store) async {
    final token = await store.read('token');
    final baseUrl = await store.read('base_url');
    final userId = int.tryParse(await store.read('user_id') ?? '');

    if (token == null || baseUrl == null || userId == null) {
      return null;
    }

    return Session(
      baseUrl: baseUrl,
      token: token,
      userId: userId,
      userName: await store.read('user_name') ?? '',
    );
  }

  Future<void> login({
    required String baseUrl,
    required String email,
    required String password,
    String? code,
  }) async {
    final store = ref.read(storeProvider);

    // Generated once and kept: the server issues one token per device id.
    var deviceId = await store.read('device_id');
    if (deviceId == null) {
      deviceId = const Uuid().v4();
      await store.write('device_id', deviceId);
    }

    final result = await HttpWeaverApi(baseUrl).login(
      email: email.trim().toLowerCase(),
      password: password,
      code: code,
      device: {
        'id': deviceId,
        'name': Platform.localHostname,
        'platform': Platform.isIOS ? 'ios' : 'android',
        'app_version': appVersion,
      },
    );

    // Another person's surveys must not show up for this one.
    if (await store.read('user_id') != '${result.userId}') {
      await ref.read(databaseProvider).clearDownloads();
    }

    await store.write('base_url', baseUrl);
    await store.write('token', result.token);
    await store.write('user_id', '${result.userId}');
    await store.write('user_name', result.userName);

    state = Session(baseUrl: baseUrl, token: result.token, userId: result.userId, userName: result.userName);
  }

  /// Sign out. The token is revoked when there is network; either way the
  /// phone forgets it. Responses not yet sent stay on the phone.
  Future<void> logout({bool revoke = true}) async {
    final api = ref.read(apiProvider);
    final store = ref.read(storeProvider);

    if (revoke && api != null) {
      try {
        await api.logout();
      } on ApiException {
        // Offline or already revoked: nothing else to do.
      }
    }

    await store.delete('token');
    state = null;
  }
}
