import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../app/session.dart';
import '../data/database.dart';
import '../survey/rules.dart';
import 'survey_form_screen.dart';

/// Shown after saving a response. In the field the next survey is usually the
/// same one at the next door, so the main button starts it right away.
class SavedScreen extends ConsumerWidget {
  const SavedScreen({super.key, required this.survey, required this.carriedOver});

  final Survey survey;

  /// What the next survey starts with (the answers the survey asked to remember).
  final Answers carriedOver;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final db = ref.watch(databaseProvider);
    final theme = Theme.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return Scaffold(
      appBar: AppBar(title: Text(survey.title), automaticallyImplyLeading: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.check_circle, size: 72, color: Colors.green),
              const SizedBox(height: 12),
              Text('Respuesta guardada', textAlign: TextAlign.center, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              if (session != null)
                StreamBuilder<int>(
                  stream: db.watchCountSince(session.userId, today),
                  builder: (context, doneToday) => StreamBuilder<int>(
                    stream: db.watchPendingCount(session.userId),
                    builder: (context, pending) => Text(
                      key: const Key('saved-counters'),
                      _counters(doneToday.data ?? 0, pending.data ?? 0),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              FilledButton.icon(
                key: const Key('new-survey'),
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => SurveyFormScreen(survey: survey, carriedOver: carriedOver),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Nueva encuesta'),
              ),
              if (carriedOver.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    carriedOver.length == 1
                        ? 'Se repetirá 1 respuesta de esta.'
                        : 'Se repetirán ${carriedOver.length} respuestas de esta.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              const SizedBox(height: 12),
              OutlinedButton(
                key: const Key('go-home'),
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                child: const Text('Volver al inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _counters(int today, int pending) {
    final done = today == 1 ? 'Llevas 1 hoy' : 'Llevas $today hoy';
    final send = pending == 0
        ? 'todo enviado'
        : pending == 1
        ? '1 por enviar'
        : '$pending por enviar';

    return '$done · $send';
  }
}
