import 'package:hive_ce/hive_ce.dart';

import '../models/move_log_entry.dart';

class LogRepository {
  Box<MoveLogEntry> get _box => Hive.box<MoveLogEntry>('history_box');

  List<MoveLogEntry> getAll() => _box.values.toList();

  List<MoveLogEntry> getBySession(String sessionId) =>
      _box.values.where((e) => e.sessionId == sessionId).toList();

  Future<void> add(MoveLogEntry entry) => _box.add(entry);
}
