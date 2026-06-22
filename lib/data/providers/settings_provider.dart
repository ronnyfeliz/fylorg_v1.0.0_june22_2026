import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';

class AppSettings {
  final bool subfolderByExt;

  const AppSettings({this.subfolderByExt = true});
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    final box = Hive.box('settings_box');
    final subfolder =
        box.get('subfolderByExt', defaultValue: true) as bool;
    return AppSettings(subfolderByExt: subfolder);
  }

  void toggleSubfolderByExt() {
    final newVal = !state.subfolderByExt;
    Hive.box('settings_box').put('subfolderByExt', newVal);
    state = AppSettings(subfolderByExt: newVal);
  }
}
