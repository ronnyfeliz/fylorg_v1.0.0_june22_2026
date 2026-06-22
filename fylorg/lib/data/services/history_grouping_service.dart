import '../models/move_log_entry.dart';

class HistoryGroup {
  final String sessionId;
  final DateTime firstTimestamp;
  final List<MoveLogEntry> entries;

  HistoryGroup({
    required this.sessionId,
    required this.firstTimestamp,
    required this.entries,
  });

  int get count => entries.length;
}

/// Agrupa entradas por sessionId y ordena grupos por timestamp descendente.
List<HistoryGroup> groupBySession(List<MoveLogEntry> entries) {
  final Map<String, List<MoveLogEntry>> grouped = {};
  for (final entry in entries) {
    grouped.putIfAbsent(entry.sessionId, () => []).add(entry);
  }
  final groups = grouped.entries.map((e) {
    final sorted = e.value
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return HistoryGroup(
      sessionId: e.key,
      firstTimestamp: sorted.first.timestamp,
      entries: sorted,
    );
  }).toList();
  groups.sort((a, b) => b.firstTimestamp.compareTo(a.firstTimestamp));
  return groups;
}
