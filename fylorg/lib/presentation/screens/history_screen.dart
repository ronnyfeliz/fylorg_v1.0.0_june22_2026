import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/l10n/app_translations.dart';
import '../../core/utils/category_visuals.dart';
import '../../data/models/move_log_entry.dart';
import '../../data/providers/history_provider.dart';
import '../../data/providers/organize_provider.dart';
import '../../data/services/history_grouping_service.dart';

class HistoryScreen extends ConsumerWidget {
  final bool isTab;
  const HistoryScreen({super.key, this.isTab = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);
    final theme = Theme.of(context);
    final t = AppTranslations.fromLocale(
      Localizations.localeOf(context).toString(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(t.get('history')),
        automaticallyImplyLeading: !isTab,
        actions: [
          if (!isTab)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton.filledTonal(
                icon: const Icon(Icons.home_rounded),
                tooltip: t.get('go_home'),
                onPressed: () =>
                    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false),
              ),
            ),
        ],
      ),
      floatingActionButton: isTab || history.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () =>
                  Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false),
              icon: const Icon(Icons.home_rounded),
              label: Text(t.get('go_home')),
            ),
      body: history.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.history_toggle_off_rounded,
                    size: 72,
                    color: theme.colorScheme.onSurface.withOpacity(0.2),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    t.get('no_history'),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: groupBySession(history).length,
              itemBuilder: (_, i) {
                final group = groupBySession(history)[i];
                return _SessionCard(group: group);
              },
            ),
    );
  }
}

class _SessionCard extends ConsumerWidget {
  final HistoryGroup group;

  const _SessionCard({required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final t = AppTranslations.fromLocale(
      Localizations.localeOf(context).toString(),
    );
    final locale = Localizations.localeOf(context);
    final dateStr = DateFormat('d MMMM yyyy — HH:mm', locale.toString())
        .format(group.firstTimestamp);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
          foregroundColor: theme.colorScheme.primary,
          child: Text(
            '${group.count}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        title: Text(
          dateStr,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${group.count} ${t.get('organized_by_session')}',
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
        shape: const Border(), // Removes bottom line from expansion tile
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          const Divider(height: 1),
          const SizedBox(height: 8),
          ...group.entries.map((entry) => _fileDetailTile(context, entry)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _revertSession(context, ref, t),
              icon: const Icon(Icons.undo_rounded, size: 18),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
                side: BorderSide(color: theme.colorScheme.error.withOpacity(0.3)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              label: Text(t.get('revert')),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _fileDetailTile(BuildContext context, MoveLogEntry entry) {
    final theme = Theme.of(context);
    final fileName = entry.originalPath.split(Platform.pathSeparator).last;
    final catName = _categoryName(entry.destinationPath);
    final visuals = CategoryVisuals.get(catName);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            entry.wasRenamed ? Icons.drive_file_rename_outline_rounded : Icons.check_circle_outline_rounded,
            color: entry.wasRenamed ? Colors.amber : Colors.green,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  '${entry.originalPath} ➔ ${entry.destinationPath}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: visuals.primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              catName,
              style: TextStyle(
                color: visuals.primaryColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _categoryName(String path) {
    final parts = path.split(Platform.pathSeparator);
    return parts.length > 2 ? parts[parts.length - 2] : '?';
  }

  void _revertSession(
      BuildContext context, WidgetRef ref, AppTranslations t) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.get('confirm_revert')),
        content: Text(t.get('confirm_revert_msg')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(t.get('cancel'))),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref
                  .read(organizeProvider.notifier)
                  .revertSession(group.sessionId);
              ref.read(historyProvider.notifier).refresh();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle_outline_rounded, color: Colors.white),
                      const SizedBox(width: 12),
                      Text(t.get('reverted')),
                    ],
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            child: Text(t.get('revert')),
          ),
        ],
      ),
    );
  }
}
