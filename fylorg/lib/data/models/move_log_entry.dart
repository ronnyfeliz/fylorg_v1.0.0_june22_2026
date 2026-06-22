import 'package:hive_ce/hive_ce.dart';

part 'move_log_entry.g.dart';

@HiveType(typeId: 1)
class MoveLogEntry {
  @HiveField(0)
  final String originalPath;

  @HiveField(1)
  final String destinationPath;

  @HiveField(2)
  final bool wasRenamed;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final String sessionId;

  const MoveLogEntry({
    required this.originalPath,
    required this.destinationPath,
    required this.wasRenamed,
    required this.timestamp,
    required this.sessionId,
  });
}
