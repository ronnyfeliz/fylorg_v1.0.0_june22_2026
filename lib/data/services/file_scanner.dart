import 'dart:io';

import '../models/file_item.dart';
import '../models/organize_rule.dart';

class ScanResult {
  final List<FileItem> files;
  final Map<String, int> summary;

  ScanResult({required this.files, required this.summary});
}

enum ScanMode { looseOnly, allFiles }

class FileScanner {
  final List<OrganizeRule> rules;
  final ScanMode mode;

  FileScanner(this.rules, {this.mode = ScanMode.allFiles});

  ScanResult scanDirectory(String rootPath) {
    final rootDir = Directory(rootPath);
    if (!rootDir.existsSync()) {
      throw Exception('El directorio no existe: $rootPath');
    }

    final files = <FileItem>[];
    _walkDirectory(rootDir, rootPath, files);

    final summary = <String, int>{};
    for (final f in files) {
      summary[f.category] = (summary[f.category] ?? 0) + 1;
    }

    return ScanResult(files: files, summary: summary);
  }

  void _walkDirectory(Directory dir, String rootPath, List<FileItem> results) {
    try {
      final entities = dir.listSync();
      for (final entity in entities) {
        if (entity is File) {
          final file = entity;
          final name = file.uri.pathSegments.last;
          final ext = _extension(name);
          final path = file.path;

          // Calcular subcarpeta relativa
          final parentDir = file.parent.path;
          String? subfolder;
          if (parentDir.length > rootPath.length) {
            subfolder = parentDir.substring(rootPath.length + 1);
          }

          final cat = _categorize(ext);
          if (cat != null) {
            results.add(FileItem(
              path: path,
              name: name,
              extension: ext,
              sizeBytes: file.lengthSync(),
              category: cat,
              parentSubfolder: subfolder,
            ));
          }
        } else if (entity is Directory && mode == ScanMode.allFiles) {
          _walkDirectory(entity, rootPath, results);
        }
      }
    } catch (_) {
      // Saltar directorios sin permisos
    }
  }

  String? _categorize(String ext) {
    for (final rule in rules) {
      if (rule.extensions.contains(ext)) {
        return rule.isEnabled ? rule.categoryName : null;
      }
    }
    // Fallback a "Otros"
    for (final rule in rules) {
      if (rule.categoryName == 'Otros' || rule.categoryKey == 'other') {
        return rule.isEnabled ? rule.categoryName : null;
      }
    }
    return null;
  }

  String _extension(String name) {
    final dot = name.lastIndexOf('.');
    if (dot == -1) return '';
    return name.substring(dot).toLowerCase();
  }
}
