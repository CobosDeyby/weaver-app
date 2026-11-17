import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../app/session.dart';
import '../data/database.dart';
import '../sync/sync_controller.dart';
import 'responses_screen.dart';
import 'survey_form_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with WidgetsBindingObserver {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Sync when the app opens, when it comes back to the front, and every few
    // minutes while it stays open.
    Future.microtask(_sync);
    _timer = Timer.periodic(const Duration(minutes: 5), (_) => _sync());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _sync();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _sync() => ref.read(syncProvider.notifier).sync();

  Future<void> _logout(int pending) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Cerrar sesión?'),
        content: Text(
          pending == 0
              ? 'Tendrás que entrar de nuevo para seguir.'
              : 'Tienes $pending respuestas sin enviar. Se quedan en este teléfono y se envían cuando vuelvas a entrar con esta cuenta.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Cerrar sesión')),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(sessionProvider.notifier).logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final sync = ref.watch(syncProvider);
    final db = ref.watch(databaseProvider);

    if (session == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<int>(
      stream: db.watchPendingCount(session.userId),
      builder: (context, pendingSnapshot) {
        final pending = pendingSnapshot.data ?? 0;

        return Scaffold(
          appBar: AppBar(
            title: Text(session.userName.isEmpty ? 'Encuestas' : session.userName),
            actions: [
              IconButton(
                tooltip: 'Mis respuestas',
                icon: const Icon(Icons.history),
                onPressed: () =>
                    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const ResponsesScreen())),
              ),
              IconButton(
                tooltip: 'Cerrar sesión',
                icon: const Icon(Icons.logout),
                onPressed: () => _logout(pending),
              ),
            ],
          ),
          body: Column(
            children: [
              _SyncBanner(sync: sync, pending: pending, onSync: _sync),
              Expanded(
                child: StreamBuilder<List<Survey>>(
                  stream: db.watchSurveys(),
                  builder: (context, snapshot) {
                    final surveys = snapshot.data ?? const <Survey>[];

                    if (surveys.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            sync.running ? 'Descargando tus encuestas…' : 'No tienes encuestas asignadas. Si esperabas alguna, sincroniza con conexión o consulta a tu supervisor.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: surveys.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final survey = surveys[index];

                        return ListTile(
                          title: Text(survey.title),
                          subtitle: Text('${survey.organization} · versión ${survey.version}'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(builder: (_) => SurveyFormScreen(survey: survey)),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SyncBanner extends StatelessWidget {
  const _SyncBanner({required this.sync, required this.pending, required this.onSync});

  final SyncState sync;
  final int pending;
  final VoidCallback onSync;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = sync.running
        ? 'Sincronizando…'
        : pending > 0
        ? '$pending ${pending == 1 ? 'respuesta' : 'respuestas'} por enviar'
        : sync.message ?? 'Sin respuestas por enviar';

    return Material(
      color: pending > 0 ? scheme.tertiaryContainer : scheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text, key: const Key('sync-status')),
                  if (!sync.running && pending > 0 && sync.failed && sync.message != null)
                    Text(sync.message!, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: sync.running ? null : onSync,
              icon: const Icon(Icons.sync),
              label: const Text('Sincronizar'),
            ),
          ],
        ),
      ),
    );
  }
}
