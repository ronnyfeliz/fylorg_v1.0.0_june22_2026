import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';

final themeProvider =
    NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final box = Hive.box('settings_box');
    final dark = box.get('darkMode', defaultValue: false) as bool;
    return dark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggle() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    Hive.box('settings_box').put('darkMode', state == ThemeMode.dark);
  }
}
