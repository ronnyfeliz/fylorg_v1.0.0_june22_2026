import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/organize_rule.dart';
import '../repositories/rules_repository.dart';

final rulesRepositoryProvider = Provider<RulesRepository>((ref) {
  return RulesRepository();
});

final rulesProvider =
    NotifierProvider<RulesNotifier, List<OrganizeRule>>(RulesNotifier.new);

class RulesNotifier extends Notifier<List<OrganizeRule>> {
  @override
  List<OrganizeRule> build() {
    return ref.read(rulesRepositoryProvider).getAllRules();
  }

  void refresh() {
    state = ref.read(rulesRepositoryProvider).getAllRules();
  }

  Future<void> add(OrganizeRule rule) async {
    await ref.read(rulesRepositoryProvider).addRule(rule);
    refresh();
  }

  Future<void> update(int index, OrganizeRule rule) async {
    await ref.read(rulesRepositoryProvider).updateRule(index, rule);
    refresh();
  }

  Future<void> delete(int index) async {
    await ref.read(rulesRepositoryProvider).deleteRule(index);
    refresh();
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    final rules = [...state];
    final moved = rules.removeAt(oldIndex);
    rules.insert(newIndex, moved);
    final repo = ref.read(rulesRepositoryProvider);
    for (var i = 0; i < rules.length; i++) {
      await repo.updateRule(i, rules[i].copyWith(order: i));
    }
    refresh();
  }
}
