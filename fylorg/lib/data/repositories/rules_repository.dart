import 'package:hive_ce/hive_ce.dart';

import '../../core/constants/file_categories.dart';
import '../models/organize_rule.dart';

class RulesRepository {
  Box<OrganizeRule> get _box => Hive.box<OrganizeRule>('rules_box');

  /// Abre el box y siembra reglas por defecto si está vacío.
  Future<void> init() async {
    final box = await Hive.openBox<OrganizeRule>('rules_box');
    if (box.isEmpty) {
      for (final rule in defaultRules()) {
        box.add(rule);
      }
    }
  }

  List<OrganizeRule> getAllRules() => _box.values.toList();

  Future<void> addRule(OrganizeRule rule) => _box.add(rule);

  Future<void> updateRule(int index, OrganizeRule rule) =>
      _box.putAt(index, rule);

  Future<void> deleteRule(int index) => _box.deleteAt(index);
}
