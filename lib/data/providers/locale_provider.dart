import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';

final localeProvider =
    NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final box = Hive.box('settings_box');
    final saved = box.get('selected_locale', defaultValue: '') as String;
    if (saved.isNotEmpty) return Locale(saved);
    return WidgetsBinding.instance.platformDispatcher.locale;
  }

  void setLocale(String code) {
    Hive.box('settings_box').put('selected_locale', code);
    state = Locale(code);
  }
}
