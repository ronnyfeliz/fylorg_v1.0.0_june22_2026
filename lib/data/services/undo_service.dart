import 'dart:io';

import '../models/move_log_entry.dart';
import '../repositories/log_repository.dart';

class UndoResult {
  final int reverted;
  final int errors;

  UndoResult({required this.reverted, required this.errors});
}

class UndoService {
  final LogRepository _logRepo;

  UndoService(this._logRepo);

  /// Revierte todos los movimientos de una sesión en orden inverso
  /// y elimina las carpetas vacías que hayan quedado.
  UndoResult revertSession(String sessionId) {
    final entries = _logRepo.getBySession(sessionId);
    var reverted = 0;
    var errors = 0;
    final dirsToClean = <String>{};

    for (final entry in entries.reversed) {
      try {
        final src = File(entry.destinationPath);
        if (!src.existsSync()) continue;

        final destDir = _parentDir(entry.originalPath);
        Directory(destDir).createSync(recursive: true);
        src.renameSync(entry.originalPath);

        dirsToClean.add(_parentDir(entry.destinationPath));
        reverted++;
      } catch (_) {
        errors++;
      }
    }

    _cleanEmptyDirs(dirsToClean);
    return UndoResult(reverted: reverted, errors: errors);
  }

  void _cleanEmptyDirs(Set<String> dirs) {
    final sorted = dirs.toList()
      ..sort((a, b) => b.length.compareTo(a.length));

    for (final dir in sorted) {
      _removeIfEmpty(dir);
    }
  }

  void _removeIfEmpty(String path) {
    try {
      final dir = Directory(path);
      if (!dir.existsSync()) return;

      // Intenta eliminar — solo funciona si está vacío
      dir.deleteSync();
      // Si llegó acá se eliminó → probar el padre
      final parent = _parentDir(path);
      if (parent != path) _removeIfEmpty(parent);
    } catch (_) {
      // Directorio no vacío o sin permisos — ignorar
    }
  }

  String _parentDir(String path) {
    return Directory(path).parent.path;
  }
}
