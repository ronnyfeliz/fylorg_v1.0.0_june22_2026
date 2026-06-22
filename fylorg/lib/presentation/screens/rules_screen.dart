import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/app_translations.dart';
import '../../core/utils/category_localizer.dart';
import '../../data/models/organize_rule.dart';
import '../../data/providers/rules_provider.dart';
import '../widgets/rule_form_dialog.dart';
import '../widgets/rule_tile.dart';

class RulesScreen extends ConsumerWidget {
  final bool isTab;
  const RulesScreen({super.key, this.isTab = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rules = ref.watch(rulesProvider);
    final theme = Theme.of(context);
    final t = AppTranslations.fromLocale(
      Localizations.localeOf(context).toString(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(t.get('rules_title')),
        automaticallyImplyLeading: !isTab,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton.filledTonal(
              icon: const Icon(Icons.add_rounded),
              onPressed: () => _showForm(context, ref, t),
              tooltip: t.get('new_rule'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (rules.isNotEmpty) ...[
            _buildStatsCard(context, theme, rules, t),
          ],
          Expanded(
            child: rules.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.rule_folder_outlined, size: 72, color: theme.colorScheme.onSurface.withOpacity(0.2)),
                        const SizedBox(height: 16),
                        Text(
                          t.get('no_rules'),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  )
                : ReorderableListView.builder(
                    buildDefaultDragHandles: false,
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: rules.length,
                    onReorder: (old, new_) {
                      // Adjust index if dragging down
                      var adjustedNew = new_;
                      if (adjustedNew > old) {
                        adjustedNew -= 1;
                      }
                      ref.read(rulesProvider.notifier).reorder(old, adjustedNew);
                    },
                    itemBuilder: (context, i) {
                      final rule = rules[i];
                      return Card(
                        key: ValueKey(rule.hashCode),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: RuleTile(
                          rule: rule,
                          index: i,
                          onEdit: () => _showForm(context, ref, t, existing: rule, index: i),
                          onDelete: () => _confirmDelete(
                            context,
                            ref,
                            i,
                            CategoryLocalizer.localizeRuleCategory(rule, context),
                            t,
                          ),
                          onToggle: (val) {
                            final updated = rule.copyWith(isEnabled: val);
                            ref.read(rulesProvider.notifier).update(i, updated);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context, ThemeData theme, List<OrganizeRule> rules, AppTranslations t) {
    final totalRules = rules.length;
    final activeRules = rules.where((r) => r.isEnabled).length;
    final inactiveRules = totalRules - activeRules;

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Row(
          children: [
            Expanded(
              child: _buildStatItem(
                icon: Icons.rule_folder_rounded,
                label: t.get('total_rules') != '' ? t.get('total_rules') : 'Total',
                value: '$totalRules',
                color: theme.colorScheme.primary,
              ),
            ),
            _buildVerticalDivider(theme),
            Expanded(
              child: _buildStatItem(
                icon: Icons.check_circle_rounded,
                label: t.get('active_rules') != '' ? t.get('active_rules') : 'Activas',
                value: '$activeRules',
                color: Colors.green,
              ),
            ),
            _buildVerticalDivider(theme),
            Expanded(
              child: _buildStatItem(
                icon: Icons.cancel_rounded,
                label: t.get('inactive_rules') != '' ? t.get('inactive_rules') : 'Inactivas',
                value: '$inactiveRules',
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider(ThemeData theme) {
    return Container(
      width: 1,
      height: 28,
      color: theme.colorScheme.outline.withOpacity(0.15),
    );
  }

  void _showForm(BuildContext context, WidgetRef ref, AppTranslations t,
      {OrganizeRule? existing, int? index}) async {
    final result = await showDialog<OrganizeRule>(
      context: context,
      builder: (_) => RuleFormDialog(existing: existing, translations: t),
    );
    if (result == null) return;
    if (existing != null && index != null) {
      ref.read(rulesProvider.notifier).update(index, result);
    } else {
      ref.read(rulesProvider.notifier).add(result);
    }
  }

  void _confirmDelete(
      BuildContext context, WidgetRef ref, int index, String name, AppTranslations t) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.get('delete_rule')),
        content: Text(t.get('delete_rule_msg').replaceAll('{name}', name)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(t.get('cancel'))),
          FilledButton(
            onPressed: () {
              ref.read(rulesProvider.notifier).delete(index);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            child: Text(t.get('delete')),
          ),
        ],
      ),
    );
  }
}
