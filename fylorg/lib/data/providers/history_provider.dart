import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/move_log_entry.dart';
import '../repositories/log_repository.dart';
import 'organize_provider.dart';

final historyProvider = NotifierProvider<HistoryNotifier, List<MoveLogEntry>>(
  HistoryNotifier.new,
);

class HistoryNotifier extends Notifier<List<MoveLogEntry>> {
  @override
  List<MoveLogEntry> build() {
    ref.listen(organizeProvider, (_, next) {
      if (next.moved > 0) refresh();
    });
    return ref.read(logRepositoryProvider).getAll();
  }

  void refresh() {
    state = ref.read(logRepositoryProvider).getAll();
  }
}
