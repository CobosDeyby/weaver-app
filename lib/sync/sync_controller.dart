import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api.dart';
import '../app/session.dart';
import 'sync_service.dart';

class SyncState {
  const SyncState({this.running = false, this.message, this.failed = false, this.lastSuccess});

  final bool running;

  /// Outcome of the last attempt, worded for the surveyor.
  final String? message;
  final bool failed;
  final DateTime? lastSuccess;
}

final syncProvider = NotifierProvider<SyncController, SyncState>(SyncController.new);

class SyncController extends Notifier<SyncState> {
  @override
  SyncState build() => const SyncState();

  /// Sync now. Calls made while one is running are ignored; the running one
  /// already picks up everything pending.
  Future<void> sync() async {
    final api = ref.read(apiProvider);
    final session = ref.read(sessionProvider);

    if (state.running || api == null || session == null) {
      return;
    }

    state = SyncState(running: true, lastSuccess: state.lastSuccess);

    try {
      final report = await SyncService(ref.read(databaseProvider), api, session.userId).run();
      final parts = [
        if (report.sent > 0) '${report.sent} enviadas',
        if (report.rejected > 0) '${report.rejected} rechazadas',
        if (report.surveysUpdated > 0) '${report.surveysUpdated} encuestas actualizadas',
      ];

      state = SyncState(
        message: parts.isEmpty ? 'Todo al día.' : '${parts.join(', ')}.',
        failed: report.rejected > 0,
        lastSuccess: DateTime.now(),
      );
    } on ApiException catch (error) {
      state = SyncState(message: error.message, failed: true, lastSuccess: state.lastSuccess);

      if (error.unauthorized) {
        await ref.read(sessionProvider.notifier).logout(revoke: false);
      }
    }
  }
}
