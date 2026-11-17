import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../app/session.dart';
import '../data/database.dart';

/// Why the server refused a response, in words a surveyor can act on.
String rejectionText(String? reason) => switch (reason) {
  'not_assigned' => 'Ya no tienes asignada esta encuesta. Avisa a tu supervisor.',
  'survey_closed' => 'La encuesta se cerró antes de que tomaras esta respuesta.',
  'unknown_version' => 'La versión de la encuesta ya no existe en el servidor.',
  'id_conflict' => 'Otra persona ya envió una respuesta con este identificador.',
  _ => 'El servidor no pudo leer esta respuesta.',
};

class ResponsesScreen extends ConsumerWidget {
  const ResponsesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final db = ref.watch(databaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis respuestas')),
      body: session == null
          ? const SizedBox.shrink()
          : StreamBuilder<List<Response>>(
              stream: db.watchResponses(session.userId),
              builder: (context, snapshot) {
                final responses = snapshot.data ?? const <Response>[];

                if (responses.isEmpty) {
                  return const Center(child: Text('Aún no has tomado respuestas en este teléfono.'));
                }

                return ListView.separated(
                  itemCount: responses.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final response = responses[index];
                    final when = MaterialLocalizations.of(context);
                    final date =
                        '${when.formatShortDate(response.finishedAt)} '
                        '${when.formatTimeOfDay(TimeOfDay.fromDateTime(response.finishedAt))}';
                    final (icon, color, label) = switch (response.status) {
                      'synced' => (Icons.cloud_done, Colors.green, 'Enviada'),
                      'rejected' => (Icons.error, Theme.of(context).colorScheme.error, 'Rechazada'),
                      _ => (Icons.schedule, Colors.orange, 'Por enviar'),
                    };

                    return ListTile(
                      leading: Icon(icon, color: color),
                      title: Text(response.surveyTitle),
                      subtitle: Text(
                        response.status == 'rejected'
                            ? '$date\n${rejectionText(response.reason)}'
                            : '$date · $label',
                      ),
                      isThreeLine: response.status == 'rejected',
                    );
                  },
                );
              },
            ),
    );
  }
}
