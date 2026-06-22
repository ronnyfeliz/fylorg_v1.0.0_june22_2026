import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/move_log_entry.dart';
import '../repositories/log_repository.dart';
import '../services/file_organizer.dart';
import '../services/undo_service.dart';
import 'rules_provider.dart';
import 'scan_provider.dart';
import 'settings_provider.dart';

final logRepositoryProvider = Provider<LogRepository>((ref) {
  return LogRepository();
});

class OrganizeState {
  final bool organizing;
  final int moved;
  final int errors;
  final List<MoveLogEntry> entries;
  final String? sessionId;
  final int elapsedMs;
  final int foldersCreated;

  const OrganizeState({
    this.organizing = false,
    this.moved = 0,
    this.errors = 0,
    this.entries = const [],
    this.sessionId,
    this.elapsedMs = 0,
    this.foldersCreated = 0,
  });

  OrganizeState copyWith({
    bool? organizing,
    int? moved,
    int? errors,
    List<MoveLogEntry>? entries,
    String? sessionId,
    int? elapsedMs,
    int? foldersCreated,
  }) =>
      OrganizeState(
        organizing: organizing ?? this.organizing,
        moved: moved ?? this.moved,
        errors: errors ?? this.errors,
        entries: entries ?? this.entries,
        sessionId: sessionId ?? this.sessionId,
        elapsedMs: elapsedMs ?? this.elapsedMs,
        foldersCreated: foldersCreated ?? this.foldersCreated,
      );
}

final organizeProvider =
    NotifierProvider<OrganizeNotifier, OrganizeState>(OrganizeNotifier.new);

class OrganizeNotifier extends Notifier<OrganizeState> {
  @override
  OrganizeState build() => const OrganizeState();

  Future<void> runOrganize(BuildContext context) async {
    final scanState = ref.read(scanProvider);
    if (scanState.files.isEmpty) return;

    state = state.copyWith(organizing: true);

    final rules = ref.read(rulesProvider);
    final logRepo = ref.read(logRepositoryProvider);
    final settings = ref.read(settingsProvider);
    final sessionId = DateTime.now().millisecondsSinceEpoch.toString();

    final organizer = FileOrganizer(
      logRepo: logRepo,
      rules: rules,
      rootPath: scanState.directoryPath!,
      sessionId: sessionId,
      subfolderByExt: settings.subfolderByExt,
      context: context,
    );

    final stopwatch = Stopwatch()..start();
    final result = organizer.organize(scanState.files);
    stopwatch.stop();

    state = state.copyWith(
      organizing: false,
      moved: result.moved,
      errors: result.errors,
      entries: result.entries,
      sessionId: sessionId,
      elapsedMs: stopwatch.elapsedMilliseconds,
      foldersCreated: result.foldersCreated,
    );
  }

  UndoResult revertSession(String sessionId) {
    final logRepo = ref.read(logRepositoryProvider);
    final undo = UndoService(logRepo);
    final result = undo.revertSession(sessionId);
    state = const OrganizeState();
    return result;
  }

  void clear() {
    state = const OrganizeState();
  }
}
