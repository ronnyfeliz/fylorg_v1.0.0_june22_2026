import 'dart:io' show Platform;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/file_item.dart';
import '../models/organize_rule.dart';
import '../services/file_scanner.dart';
import 'rules_provider.dart';

class ScanState {
  final String? directoryPath;
  final List<FileItem> files;
  final Map<String, int> summary;
  final bool scanning;
  final ScanMode scanMode;

  const ScanState({
    this.directoryPath,
    this.files = const [],
    this.summary = const {},
    this.scanning = false,
    this.scanMode = ScanMode.allFiles,
  });

  ScanState copyWith({
    String? directoryPath,
    List<FileItem>? files,
    Map<String, int>? summary,
    bool? scanning,
    ScanMode? scanMode,
  }) =>
      ScanState(
        directoryPath: directoryPath ?? this.directoryPath,
        files: files ?? this.files,
        summary: summary ?? this.summary,
        scanning: scanning ?? this.scanning,
        scanMode: scanMode ?? this.scanMode,
      );
}

final scanProvider = NotifierProvider<ScanNotifier, ScanState>(ScanNotifier.new);

class ScanNotifier extends Notifier<ScanState> {
  @override
  ScanState build() => const ScanState();

  Future<void> pickAndScan() async {
    if (Platform.isAndroid) {
      final status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) return;
    }

    final result = await FilePicker.getDirectoryPath();
    if (result == null) return;

    state = state.copyWith(directoryPath: result);
    _scan(result);
  }

  void _scan(String path) {
    state = state.copyWith(scanning: true);

    final rules = ref.read(rulesProvider);
    final scanner = FileScanner(rules, mode: state.scanMode);
    final scanResult = scanner.scanDirectory(path);

    state = state.copyWith(
      files: scanResult.files,
      summary: scanResult.summary,
      scanning: false,
    );
  }

  void setScanMode(ScanMode mode) {
    state = state.copyWith(scanMode: mode);
    if (state.directoryPath != null) {
      _scan(state.directoryPath!);
    }
  }

  void clear() => state = const ScanState();
}
