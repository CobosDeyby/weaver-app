import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'app/secure_store.dart';
import 'app/session.dart';
import 'data/database.dart';
import 'ui/home_screen.dart';
import 'ui/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const store = SecureStore();
  final directory = await getApplicationDocumentsDirectory();
  final database = AppDatabase(
    NativeDatabase.createInBackground(File(p.join(directory.path, 'weaver.sqlite'))),
  );

  runApp(
    ProviderScope(
      overrides: [
        storeProvider.overrideWithValue(store),
        databaseProvider.overrideWithValue(database),
        initialSessionProvider.overrideWithValue(await SessionController.restore(store)),
      ],
      child: const WeaverApp(),
    ),
  );
}

class WeaverApp extends ConsumerWidget {
  const WeaverApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signedIn = ref.watch(sessionProvider) != null;

    return MaterialApp(
      title: 'Weaver',
      theme: ThemeData(colorSchemeSeed: const Color(0xFF1F5FBF), useMaterial3: true),
      darkTheme: ThemeData(
        colorSchemeSeed: const Color(0xFF1F5FBF),
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: signedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}
