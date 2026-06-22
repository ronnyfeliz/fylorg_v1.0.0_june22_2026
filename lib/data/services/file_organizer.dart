import 'dart:io';

import 'package:flutter/material.dart';

import '../models/file_item.dart';
import '../models/move_log_entry.dart';
import '../models/organize_rule.dart';
import '../repositories/log_repository.dart';
import '../../core/utils/category_localizer.dart';

class OrganizeResult {
  final List<MoveLogEntry> entries;
  final int moved;
  final int errors;
  final int foldersCreated;

  OrganizeResult({
    required this.entries,
    required this.moved,
    required this.errors,
    required this.foldersCreated,
  });
}

class FileOrganizer {
  final LogRepository _logRepo;
  final List<OrganizeRule> rules;
  final String rootPath;
  final String sessionId;
  final bool subfolderByExt;
  final BuildContext context;

  FileOrganizer({
    required LogRepository logRepo,
    required this.rules,
    required this.rootPath,
    required this.sessionId,
    this.subfolderByExt = true,
    required this.context,
  }) : _logRepo = logRepo;

  OrganizeResult organize(List<FileItem> files) {
    var moved = 0;
    var errors = 0;
    final entries = <MoveLogEntry>[];
    final createdDirs = <String>{};

    for (final file in files) {
      try {
        final destDir = _destinationDir(file);

        // Count folders to be created recursively
        var current = Directory(destDir);
        while (current.path.length > rootPath.length) {
          if (!current.existsSync() && !createdDirs.contains(current.path)) {
            createdDirs.add(current.path);
          }
          current = current.parent;
        }

        final destPath = _resolvePath(file, destDir);

        Directory(destDir).createSync(recursive: true);
        File(file.path).renameSync(destPath);

        final entry = MoveLogEntry(
          originalPath: file.path,
          destinationPath: destPath,
          wasRenamed: destPath != _simpleDestPath(file, destDir),
          timestamp: DateTime.now(),
          sessionId: sessionId,
        );
        entries.add(entry);
        _logRepo.add(entry);
        moved++;
      } catch (_) {
        errors++;
      }
    }

    return OrganizeResult(
      entries: entries,
      moved: moved,
      errors: errors,
      foldersCreated: createdDirs.length,
    );
  }

  String _folderName(OrganizeRule rule) {
    if (rule.customFolderName != null && rule.customFolderName!.isNotEmpty) {
      return rule.customFolderName!;
    }
    return CategoryLocalizer.getDisplayName(
      rule.categoryKey,
      rule.categoryName,
      context,
    );
  }

  String _destinationDir(FileItem file) {
    for (final rule in rules) {
      if (rule.categoryName == file.category) {
        final base = '$rootPath/${_folderName(rule)}';
        if (subfolderByExt && file.extension.isNotEmpty) {
          final sub = file.extension.replaceAll('.', '').toUpperCase();
          return '$base/$sub';
        }
        return base;
      }
    }
    final base = '$rootPath/Otros';
    if (subfolderByExt && file.extension.isNotEmpty) {
      final sub = file.extension.replaceAll('.', '').toUpperCase();
      return '$base/$sub';
    }
    return base;
  }

  String _simpleDestPath(FileItem file, String destDir) {
    return '$destDir/${file.name}';
  }

  String _resolvePath(FileItem file, String destDir) {
    var destPath = _simpleDestPath(file, destDir);
    var counter = 1;
    while (File(destPath).existsSync()) {
      final dot = file.name.lastIndexOf('.');
      final base = dot == -1 ? file.name : file.name.substring(0, dot);
      final ext = dot == -1 ? '' : file.name.substring(dot);
      destPath = '$destDir/${base}_($counter)$ext';
      counter++;
    }
    return destPath;
  }
}
