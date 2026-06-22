import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/app_translations.dart';
import '../../core/utils/category_localizer.dart';
import '../../core/utils/category_visuals.dart';
import '../../data/models/move_log_entry.dart';
import '../../data/models/organize_rule.dart';
import '../../data/providers/organize_provider.dart';
import '../../data/providers/rules_provider.dart';
import '../../data/providers/scan_provider.dart';

class CategoryGroup {
  final String name; // Localized category name
  final OrganizeRule? rule;
  final int totalFiles;
  final Map<String, int> extensionsCount; // extension -> count

  CategoryGroup({
    required this.name,
    this.rule,
    required this.totalFiles,
    required this.extensionsCount,
  });
}

class ProgressScreen extends ConsumerWidget {
  final int moved;
  final int errors;
  final List<MoveLogEntry> entries;
  final String sessionId;
  final int elapsedMs;
  final int foldersCreated;

  const ProgressScreen({
    super.key,
    required this.moved,
    required this.errors,
    required this.entries,
    required this.sessionId,
    required this.elapsedMs,
    required this.foldersCreated,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppTranslations.fromLocale(
      Localizations.localeOf(context).toString(),
    );
    final theme = Theme.of(context);
    
    final groups = _buildCategoryGroups(context, ref);
    final byCategoryCount = groups.length;
    final spaceProcessed = _formatProcessedSpace(t);
    final executionTime = _formatDuration(elapsedMs, t);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.get('app_title')),
        automaticallyImplyLeading: false, // Prevents going back
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Success Header
                  _buildSuccessHeader(theme, t),
                  const SizedBox(height: 24),
                  
                  // Statistics Grid
                  _buildStatsGrid(context, moved, foldersCreated, byCategoryCount, spaceProcessed, executionTime, theme, t),
                  const SizedBox(height: 24),
                  
                  // Categories Section Header
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
                    child: Text(
                      t.get('total_organized') == 'Total files organized' ? 'ORGANIZATION SUMMARY' : 'RESUMEN DE ORGANIZACIÓN',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),

                  // Tree / Accordion list
                  if (groups.isEmpty)
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: theme.colorScheme.outline.withOpacity(0.12),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Center(
                          child: Text(
                            t.get('no_files'),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.55),
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    ...groups.map((group) => CategoryExpansionCard(group: group, translations: t)).toList(),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _confirmRevert(context, ref, t),
                          icon: const Icon(Icons.undo_rounded),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme.colorScheme.error,
                            side: BorderSide(color: theme.colorScheme.error.withOpacity(0.4)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          label: Text(t.get('revert')),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            ref.read(organizeProvider.notifier).clear();
                            ref.read(scanProvider.notifier).clear();
                            Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                          },
                          icon: const Icon(Icons.check_rounded),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          label: Text(t.get('done')),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessHeader(ThemeData theme, AppTranslations t) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.green.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.get('total_organized') == 'Total files organized' 
                      ? 'Organization Completed!' 
                      : '¡Organización completada!',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$moved ${t.get('files_organized')}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (errors > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$errors ${t.get('errors')}',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, int totalFiles, int folders, int categories, String space, String time, ThemeData theme, AppTranslations t) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;
    
    int crossAxisCount = 2;
    double childAspectRatio = 1.6;
    if (isDesktop) {
      crossAxisCount = 5;
      childAspectRatio = 1.35;
    } else if (screenWidth > 400) {
      crossAxisCount = 3;
      childAspectRatio = 1.3;
    }

    final stats = [
      _StatItem(t.get('total_organized'), '$totalFiles', Icons.insert_drive_file_rounded, theme.colorScheme.primary),
      _StatItem(t.get('folders_created'), '$folders', Icons.create_new_folder_rounded, Colors.teal),
      _StatItem(t.get('categories_used'), '$categories', Icons.category_rounded, Colors.orange),
      _StatItem(t.get('space_processed'), space, Icons.storage_rounded, Colors.cyan),
      _StatItem(t.get('execution_time'), time, Icons.speed_rounded, Colors.purple),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: stats.length,
      itemBuilder: (ctx, i) {
        final stat = stats[i];
        return Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.12),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: stat.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(stat.icon, color: stat.color, size: 18),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        stat.value,
                        style: TextStyle(
                          fontSize: isDesktop ? 16 : 14,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        stat.label,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface.withOpacity(0.55),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<CategoryGroup> _buildCategoryGroups(BuildContext context, WidgetRef ref) {
    final rules = ref.read(rulesProvider);
    final Map<String, OrganizeRule?> nameToRule = {};
    final Map<String, Map<String, int>> data = {}; // CategoryName -> extension -> count

    for (final entry in entries) {
      final parts = entry.originalPath.split(RegExp(r'[\\/]'));
      final fileName = parts.isNotEmpty ? parts.last : '';
      final dot = fileName.lastIndexOf('.');
      final ext = dot == -1 ? '' : fileName.substring(dot + 1).toLowerCase();
      final extUpper = ext.isEmpty ? 'OTHERS' : ext.toUpperCase();

      String categoryName = 'Otros';
      OrganizeRule? matchedRule;
      for (final rule in rules) {
        if (rule.extensions.contains('.$ext')) {
          categoryName = rule.categoryName;
          matchedRule = rule;
          break;
        }
      }

      final String localizedName = matchedRule != null
          ? CategoryLocalizer.localizeRuleCategory(matchedRule, context)
          : CategoryLocalizer.localizeCategory(categoryName, context);

      nameToRule[localizedName] = matchedRule;

      data.putIfAbsent(localizedName, () => {});
      data[localizedName]![extUpper] = (data[localizedName]![extUpper] ?? 0) + 1;
    }

    final List<CategoryGroup> groups = [];
    data.forEach((localizedName, exts) {
      final totalFiles = exts.values.fold<int>(0, (prev, element) => prev + element);
      groups.add(CategoryGroup(
        name: localizedName,
        rule: nameToRule[localizedName],
        totalFiles: totalFiles,
        extensionsCount: exts,
      ));
    });

    groups.sort((a, b) => b.totalFiles.compareTo(a.totalFiles));
    return groups;
  }

  String _formatProcessedSpace(AppTranslations t) {
    int totalBytes = 0;
    for (final entry in entries) {
      try {
        final file = File(entry.destinationPath);
        if (file.existsSync()) {
          totalBytes += file.lengthSync();
        }
      } catch (_) {}
    }

    if (totalBytes < 1024) {
      return '$totalBytes B';
    } else if (totalBytes < 1024 * 1024) {
      final kb = totalBytes / 1024.0;
      return '${kb.toStringAsFixed(1)} KB';
    } else if (totalBytes < 1024 * 1024 * 1024) {
      final mb = totalBytes / (1024.0 * 1024.0);
      return '${mb.toStringAsFixed(2)} MB';
    } else {
      final gb = totalBytes / (1024.0 * 1024.0 * 1024.0);
      return '${gb.toStringAsFixed(2)} GB';
    }
  }

  String _formatDuration(int ms, AppTranslations t) {
    if (ms >= 1000) {
      final seconds = ms / 1000.0;
      return '${seconds.toStringAsFixed(2)} ${t.get('seconds')}';
    }
    return '$ms ${t.get('milliseconds')}';
  }

  void _confirmRevert(BuildContext context, WidgetRef ref, AppTranslations t) {
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
              ref.read(organizeProvider.notifier).revertSession(sessionId);
              Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
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

class _StatItem {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  _StatItem(this.label, this.value, this.icon, this.color);
}

class CategoryExpansionCard extends StatefulWidget {
  final CategoryGroup group;
  final AppTranslations translations;

  const CategoryExpansionCard({
    super.key,
    required this.group,
    required this.translations,
  });

  @override
  State<CategoryExpansionCard> createState() => _CategoryExpansionCardState();
}

class _CategoryExpansionCardState extends State<CategoryExpansionCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryNameForVisuals = widget.group.rule?.categoryName ?? widget.group.name;
    final visuals = CategoryVisuals.get(categoryNameForVisuals);
    final totalFiles = widget.group.totalFiles;
    final filesWord = totalFiles == 1 ? widget.translations.get('file_single') : widget.translations.get('file_plural');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: _isExpanded 
              ? visuals.primaryColor.withOpacity(0.4)
              : theme.colorScheme.outline.withOpacity(0.12),
          width: _isExpanded ? 1.5 : 1,
        ),
      ),
      elevation: _isExpanded ? 3 : 1,
      shadowColor: _isExpanded ? visuals.primaryColor.withOpacity(0.1) : Colors.transparent,
      child: Column(
        children: [
          // Header Row
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  // Category Icon Container
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: visuals.gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      visuals.icon,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Title & File count
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.group.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$totalFiles $filesWord',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.55),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Expand/Collapse Chevron
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Subcategories list (Animated Size/Expansion)
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  const Divider(height: 16),
                  ...widget.group.extensionsCount.entries.map((extEntry) {
                    final extName = extEntry.key;
                    final count = extEntry.value;
                    final extPercent = totalFiles > 0 ? (count / totalFiles) : 0.0;
                    final percentText = (extPercent * 100).toStringAsFixed(0);
                    final extIcon = _getExtensionIcon(extName);
                    final subFilesWord = count == 1 
                        ? widget.translations.get('file_single') 
                        : widget.translations.get('file_plural');

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                extIcon,
                                size: 18,
                                color: visuals.primaryColor.withOpacity(0.7),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                extName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '$count $subFilesWord ($percentText%)',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          // Linear progress indicator for percentage
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: extPercent,
                              backgroundColor: theme.colorScheme.onSurface.withOpacity(0.05),
                              color: visuals.primaryColor,
                              minHeight: 5,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }

  IconData _getExtensionIcon(String ext) {
    final e = ext.toLowerCase().replaceAll('.', '');
    if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'svg', 'tiff', 'ico'].contains(e)) {
      return Icons.image_rounded;
    }
    if (['mp3', 'wav', 'flac', 'ogg', 'm4a', 'aac', 'wma'].contains(e)) {
      return Icons.music_note_rounded;
    }
    if (['mp4', 'mkv', 'avi', 'mov', 'wmv', 'flv', 'webm'].contains(e)) {
      return Icons.movie_rounded;
    }
    if (['pdf'].contains(e)) {
      return Icons.picture_as_pdf_rounded;
    }
    if (['doc', 'docx', 'odt'].contains(e)) {
      return Icons.description_rounded;
    }
    if (['xls', 'xlsx', 'ods', 'csv'].contains(e)) {
      return Icons.table_chart_rounded;
    }
    if (['ppt', 'pptx', 'odp'].contains(e)) {
      return Icons.slideshow_rounded;
    }
    if (['zip', 'rar', '7z', 'tar', 'gz'].contains(e)) {
      return Icons.folder_zip_rounded;
    }
    if (['dart', 'js', 'py', 'java', 'cpp', 'c', 'html', 'css', 'json', 'xml', 'ts', 'sh'].contains(e)) {
      return Icons.code_rounded;
    }
    return Icons.insert_drive_file_rounded;
  }
}
