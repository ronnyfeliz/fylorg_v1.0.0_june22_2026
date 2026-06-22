import 'package:flutter/material.dart';

import '../../core/l10n/app_translations.dart';
import '../../core/utils/category_localizer.dart';
import '../../core/utils/category_visuals.dart';
import '../../data/models/organize_rule.dart';

class RuleTile extends StatelessWidget {
  final OrganizeRule rule;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;
  final int index;

  const RuleTile({
    super.key,
    required this.rule,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppTranslations.fromLocale(
      Localizations.localeOf(context).toString(),
    );
    
    final visuals = CategoryVisuals.get(rule.categoryName);
    final folderName = rule.customFolderName ?? CategoryLocalizer.localizeRuleCategory(rule, context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 500;

        final dragHandle = ReorderableDragStartListener(
          index: index,
          child: MouseRegion(
            cursor: SystemMouseCursors.grab,
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0, top: 12.0),
              child: Icon(
                Icons.drag_indicator_rounded,
                color: theme.colorScheme.onSurface.withOpacity(0.35),
                size: 22,
              ),
            ),
          ),
        );

        final categoryIcon = Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: visuals.gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: visuals.primaryColor.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            visuals.icon,
            color: Colors.white,
            size: 24,
          ),
        );

        final badges = [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: rule.isEnabled 
                  ? Colors.green.withOpacity(0.08) 
                  : Colors.grey.withOpacity(0.08),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: rule.isEnabled 
                    ? Colors.green.withOpacity(0.2) 
                    : Colors.grey.withOpacity(0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: rule.isEnabled ? Colors.green : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  rule.isEnabled 
                      ? (t.get('rule_active') != '' ? t.get('rule_active') : 'Activa')
                      : (t.get('rule_inactive') != '' ? t.get('rule_inactive') : 'Desactivada'),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: rule.isEnabled ? Colors.green : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (rule.customFolderName != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                t.get('folder_label').replaceAll('{name}', folderName),
                style: TextStyle(
                  fontSize: 11,
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ];

        final titleAndBadges = Wrap(
          spacing: 8,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              CategoryLocalizer.localizeRuleCategory(rule, context),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            ...badges,
          ],
        );

        final extensionsWrap = rule.extensions.isEmpty
            ? Text(
                t.get('no_extensions'),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                  fontStyle: FontStyle.italic,
                ),
              )
            : Wrap(
                spacing: 6,
                runSpacing: 6,
                children: rule.extensions.map((ext) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.colorScheme.onSurface.withOpacity(0.08),
                      ),
                    ),
                    child: Text(
                      ext,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  );
                }).toList(),
              );

        final actionButtons = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton.filledTonal(
              icon: const Icon(Icons.edit_rounded, size: 16),
              onPressed: onEdit,
              style: IconButton.styleFrom(
                padding: const EdgeInsets.all(6),
              ),
            ),
            const SizedBox(width: 6),
            IconButton.filledTonal(
              icon: const Icon(Icons.delete_rounded, size: 16),
              onPressed: onDelete,
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.error.withOpacity(0.1),
                foregroundColor: theme.colorScheme.error,
                padding: const EdgeInsets.all(6),
              ),
            ),
          ],
        );

        if (isMobile) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    dragHandle,
                    Expanded(
                      child: Opacity(
                        opacity: rule.isEnabled ? 1.0 : 0.45,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            categoryIcon,
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  titleAndBadges,
                                  const SizedBox(height: 8),
                                  extensionsWrap,
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: rule.isEnabled,
                      onChanged: onToggle,
                      activeColor: Colors.green,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    actionButtons,
                  ],
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Opacity(
                  opacity: rule.isEnabled ? 1.0 : 0.45,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      dragHandle,
                      categoryIcon,
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            titleAndBadges,
                            const SizedBox(height: 12),
                            extensionsWrap,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Switch(
                    value: rule.isEnabled,
                    onChanged: onToggle,
                    activeColor: Colors.green,
                  ),
                  const SizedBox(height: 8),
                  actionButtons,
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
