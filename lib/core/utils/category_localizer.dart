import 'package:flutter/material.dart';

import '../l10n/app_translations.dart';
import '../../data/models/organize_rule.dart';

class CategoryLocalizer {
  static final Set<String> _knownKeys = {
    'images', 'audio', 'video', 'documents',
    'compressed', 'code', 'other',
  };

  static String _normalize(String input) {
    return input
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ü', 'u')
        .replaceAll('ñ', 'n');
  }

  /// Retorna el nombre localizado de una categoría según su key.
  /// Si [categoryKey] es una key conocida, traduce con el locale activo.
  /// Si no, usa [fallback] (que es el categoryName guardado).
  static String getDisplayName(
    String categoryKey,
    String fallback,
    BuildContext context,
  ) {
    if (!_knownKeys.contains(categoryKey)) return fallback;
    final locale = Localizations.localeOf(context);
    final t = AppTranslations.fromLocale(locale.toString());
    return t.get('category_$categoryKey', fallback);
  }

  /// Obtiene la key correspondiente para un nombre de categoría.
  /// Busca coincidencia exacta en las traducciones de todas las plataformas.
  static String getCategoryKeyForName(String name) {
    final clean = name.trim().toLowerCase();
    const keys = ['images', 'audio', 'video', 'documents', 'compressed', 'code', 'other'];
    
    for (final key in keys) {
      if (clean == key) return key;
    }
    
    // Mapeos manuales para español e inglés por seguridad
    if (clean == 'imágenes' || clean == 'imagenes') return 'images';
    if (clean == 'documentos') return 'documents';
    if (clean == 'comprimidos') return 'compressed';
    if (clean == 'código' || clean == 'codigo') return 'code';
    if (clean == 'otros' || clean == 'otro') return 'other';
    
    final locales = ['es', 'en', 'it', 'ru', 'ja', 'zh', 'pt', 'fr', 'ko'];
    for (final loc in locales) {
      final t = AppTranslations.fromLocale(loc);
      for (final key in keys) {
        final translated = t.get('category_$key').toLowerCase();
        if (clean == translated) {
          return key;
        }
      }
    }
    
    return '';
  }

  /// Traduce dinámicamente un nombre de categoría (sea en español, inglés o su key).
  static String localizeCategory(String name, BuildContext context) {
    final clean = _normalize(name);
    String key;
    if (clean.contains('imag') || clean == 'images') {
      key = 'images';
    } else if (clean.contains('aud') || clean == 'audio') {
      key = 'audio';
    } else if (clean.contains('vid') || clean == 'video') {
      key = 'video';
    } else if (clean.contains('doc') || clean == 'documents') {
      key = 'documents';
    } else if (clean.contains('comp') || clean == 'compressed') {
      key = 'compressed';
    } else if (clean.contains('cod') || clean == 'code') {
      key = 'code';
    } else if (clean.contains('otr') || clean == 'other' || clean == 'otros') {
      key = 'other';
    } else {
      return name; // Si es personalizada, retorna el nombre tal cual
    }
    
    final locale = Localizations.localeOf(context);
    final t = AppTranslations.fromLocale(locale.toString());
    return t.get('category_$key', name);
  }

  /// Traduce de forma robusta la categoría de una regla.
  /// Intenta usar la key primero, si no, usa la coincidencia por texto.
  static String localizeRuleCategory(OrganizeRule rule, BuildContext context) {
    if (rule.categoryKey.isNotEmpty) {
      return getDisplayName(rule.categoryKey, rule.categoryName, context);
    }
    return localizeCategory(rule.categoryName, context);
  }
}
