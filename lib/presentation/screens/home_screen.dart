import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/app_translations.dart';
import '../../core/utils/category_localizer.dart';
import '../../core/utils/category_visuals.dart';
import '../../data/providers/organize_provider.dart';
import '../../data/providers/scan_provider.dart';
import '../../data/services/file_scanner.dart' show ScanMode;
import '../../data/providers/settings_provider.dart';
import '../../data/providers/theme_provider.dart';
import 'history_screen.dart';
import 'progress_screen.dart';
import 'rules_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final t = AppTranslations.fromLocale(
      Localizations.localeOf(context).toString(),
    );

    final List<Widget> tabs = [
      const DashboardTab(),
      const RulesScreen(isTab: true),
      const HistoryScreen(isTab: true),
      const SettingsScreen(isTab: true),
    ];

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 800;

          if (isCompact) {
            return Scaffold(
              body: IndexedStack(
                index: _currentIndex,
                children: tabs,
              ),
              bottomNavigationBar: NavigationBar(
                selectedIndex: _currentIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                destinations: [
                  NavigationDestination(
                    icon: const Icon(Icons.dashboard_outlined),
                    selectedIcon: const Icon(Icons.dashboard_rounded),
                    label: t.get('app_title'),
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.rule_outlined),
                    selectedIcon: const Icon(Icons.rule_rounded),
                    label: t.get('rules'),
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.history_outlined),
                    selectedIcon: const Icon(Icons.history_rounded),
                    label: t.get('history'),
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.settings_outlined),
                    selectedIcon: const Icon(Icons.settings_rounded),
                    label: t.get('settings'),
                  ),
                ],
              ),
            );
          }

          // Desktop split-pane layout with custom sidebar navigation
          return Row(
            children: [
              _buildSidebar(context, isDark, t),
              Expanded(
                child: Container(
                  color: isDark ? const Color(0xFF090D16) : const Color(0xFFF1F5F9),
                  child: IndexedStack(
                    index: _currentIndex,
                    children: tabs,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, bool isDark, AppTranslations t) {
    final theme = Theme.of(context);
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131B2E) : Colors.white,
        border: Border(
          right: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.15),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo and Title Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      'assets/logo/FYLORG_LOGO.png',
                      errorBuilder: (ctx, err, stack) => Icon(
                        Icons.folder_zip_outlined,
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fylorg',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'v1.0',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Navigation Items
            _SidebarNavItem(
              icon: Icons.dashboard_outlined,
              activeIcon: Icons.dashboard_rounded,
              label: t.get('app_title'),
              isSelected: _currentIndex == 0,
              onTap: () => setState(() => _currentIndex = 0),
            ),
            _SidebarNavItem(
              icon: Icons.rule_outlined,
              activeIcon: Icons.rule_rounded,
              label: t.get('rules'),
              isSelected: _currentIndex == 1,
              onTap: () => setState(() => _currentIndex = 1),
            ),
            _SidebarNavItem(
              icon: Icons.history_outlined,
              activeIcon: Icons.history_rounded,
              label: t.get('history'),
              isSelected: _currentIndex == 2,
              onTap: () => setState(() => _currentIndex = 2),
            ),
            _SidebarNavItem(
              icon: Icons.settings_outlined,
              activeIcon: Icons.settings_rounded,
              label: t.get('settings'),
              isSelected: _currentIndex == 3,
              onTap: () => setState(() => _currentIndex = 3),
            ),
            const Spacer(),
            // Credits Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.05),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.get('app_info').toUpperCase(),
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary.withOpacity(0.8),
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildCreditRow(Icons.person_outline_rounded, t.get('developer'), 'Innovatech', theme),
                    const SizedBox(height: 6),
                    _buildCreditRow(Icons.email_outlined, t.get('support'), 'innovatech.1801@gmail.com', theme),
                    const SizedBox(height: 6),
                    _buildCreditRow(Icons.calendar_month_outlined, t.get('release_date'), '21/05/2026', theme),
                    const SizedBox(height: 6),
                    _buildCreditRow(Icons.update_rounded, t.get('update_date'), '21/06/2026', theme),
                    const SizedBox(height: 6),
                    _buildCreditRow(Icons.info_outline_rounded, t.get('version'), '1.0', theme),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Theme Toggle Quick Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  dense: true,
                  leading: Icon(
                    isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  title: Text(
                    isDark ? t.get('light_mode') : t.get('dark_mode'),
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  onTap: () => ref.read(themeProvider.notifier).toggle(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditRow(IconData icon, String label, String value, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 14,
          color: theme.colorScheme.onSurface.withOpacity(0.4),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$label:',
                style: TextStyle(
                  fontSize: 10,
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: TextStyle(
                  fontSize: 11,
                  color: theme.colorScheme.onSurface.withOpacity(0.75),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SidebarNavItem extends StatefulWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<_SidebarNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = widget.isSelected;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withOpacity(0.08)
                : _isHovered
                    ? theme.colorScheme.onSurface.withOpacity(0.04)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    isSelected ? widget.activeIcon : widget.icon,
                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.6),
                    size: 20,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.75),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        fontSize: 13.5,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardTab extends ConsumerWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanState = ref.watch(scanProvider);
    final orgState = ref.watch(organizeProvider);
    final theme = Theme.of(context);
    final t = AppTranslations.fromLocale(
      Localizations.localeOf(context).toString(),
    );

    if (scanState.directoryPath == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(t.get('app_title')),
        ),
        body: _DashboardEmptyState(
          onPick: () => ref.read(scanProvider.notifier).pickAndScan(),
          isScanning: scanState.scanning,
          t: t,
        ),
      );
    }

    if (scanState.scanning) {
      return Scaffold(
        body: _LoadingOverlay(message: t.get('scanning')),
      );
    }

    if (orgState.organizing) {
      return Scaffold(
        body: _LoadingOverlay(message: t.get('organizing')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(t.get('app_title')),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton.filledTonal(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: t.get('scan_folder'),
              onPressed: () => ref.read(scanProvider.notifier).pickAndScan(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton.filledTonal(
              icon: const Icon(Icons.close_rounded),
              tooltip: 'Clear',
              onPressed: () => ref.read(scanProvider.notifier).clear(),
            ),
          ),
        ],
      ),
      body: _buildResultsView(context, ref, scanState, orgState, theme, t),
    );
  }

  Widget _buildResultsView(
    BuildContext context,
    WidgetRef ref,
    ScanState scanState,
    OrganizeState orgState,
    ThemeData theme,
    AppTranslations t,
  ) {
    final total = scanState.files.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
          // Header Card with Path
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.15),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.folder_rounded,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.get('files_found') == 'files found' ? 'Scanned Directory' : 'Directorio Escaneado',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          scanState.directoryPath!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Category Stats Grid
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: scanState.summary.entries.map((entry) {
              final visuals = CategoryVisuals.get(entry.key);
              final percent = total > 0 ? entry.value / total : 0.0;
              final percentText = (percent * 100).toStringAsFixed(1);
              
              return SizedBox(
                width: 160,
                child: Card(
                  elevation: 2,
                  shadowColor: visuals.primaryColor.withOpacity(0.08),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: visuals.primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: visuals.gradient,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                visuals.icon,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            Text(
                              '$percentText%',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.5),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          CategoryLocalizer.localizeCategory(entry.key, context),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${entry.value} ${entry.value == 1 ? t.get("file_single") : t.get("file_plural")}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: percent,
                            backgroundColor: visuals.primaryColor.withOpacity(0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(visuals.primaryColor),
                            minHeight: 5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          // Scanned Files List Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            child: Text(
              '$total ${t.get('files_found')}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 300,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.15),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  children: [
                    Container(
                      color: theme.colorScheme.onSurface.withOpacity(0.02),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Nombre del archivo',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Tamaño',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(width: 48),
                          Text(
                            'Categoría',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: ListView.separated(
                        itemCount: scanState.files.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final file = scanState.files[index];
                          final visuals = CategoryVisuals.get(file.category);
                          final formattedSize = _formatBytes(file.sizeBytes);
                          
                          return ListTile(
                            hoverColor: theme.colorScheme.onSurface.withOpacity(0.01),
                            leading: Icon(
                              visuals.icon,
                              color: visuals.primaryColor.withOpacity(0.7),
                              size: 20,
                            ),
                            title: Text(
                              file.name,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              file.parentSubfolder != null 
                                  ? 'Subcarpeta: ${file.parentSubfolder}' 
                                  : 'Carpeta raíz',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.4),
                                fontSize: 11,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  formattedSize,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: visuals.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    CategoryLocalizer.localizeCategory(file.category, context),
                                    style: TextStyle(
                                      color: visuals.primaryColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Settings and Action Panel
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.15),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      t.get('subfolder_by_ext'),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    subtitle: Text(
                      ref.watch(settingsProvider).subfolderByExt
                          ? t.get('subfolder_example')
                          : t.get('subfolder_flat'),
                      style: const TextStyle(fontSize: 11),
                    ),
                    value: ref.watch(settingsProvider).subfolderByExt,
                    onChanged: (_) =>
                        ref.read(settingsProvider.notifier).toggleSubfolderByExt(),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      t.get('scan_scope'),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    subtitle: Text(
                      scanState.scanMode == ScanMode.allFiles
                          ? t.get('scan_scope_all')
                          : t.get('scan_scope_loose'),
                      style: const TextStyle(fontSize: 11),
                    ),
                    value: scanState.scanMode == ScanMode.allFiles,
                    onChanged: (val) => ref
                        .read(scanProvider.notifier)
                        .setScanMode(val ? ScanMode.allFiles : ScanMode.looseOnly),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => _confirmOrganize(context, ref, scanState, t),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      ),
                      icon: const Icon(Icons.drive_file_move_rounded, size: 20),
                      label: Text(t.get('organize')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
     ),
    );
  }

  void _confirmOrganize(
    BuildContext context,
    WidgetRef ref,
    ScanState scanState,
    AppTranslations t,
  ) {
    final total = scanState.files.length;
    final cats = scanState.summary.entries
        .map((e) => '${e.key}: ${e.value}')
        .join('\n');

    final msg = t.get('confirm_organize_msg')
        .replaceAll('{total}', '$total')
        .replaceAll('{cats}', cats);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.get('confirm_organize')),
        content: Text(msg),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(t.get('cancel'))),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(organizeProvider.notifier).runOrganize(context);
              final orgState = ref.read(organizeProvider);
              if (orgState.sessionId != null) {
                final moved = orgState.moved;
                final errors = orgState.errors;
                final entries = orgState.entries;
                final sessionId = orgState.sessionId!;
                ref.read(organizeProvider.notifier).clear();
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProgressScreen(
                        moved: moved,
                        errors: errors,
                        entries: entries,
                        sessionId: sessionId,
                        elapsedMs: orgState.elapsedMs,
                        foldersCreated: orgState.foldersCreated,
                      ),
                    ),
                  );
                }
              }
            },
            child: Text(t.get('organize')),
          ),
        ],
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }
}

class _DashboardEmptyState extends StatelessWidget {
  final VoidCallback onPick;
  final bool isScanning;
  final AppTranslations t;

  const _DashboardEmptyState({
    required this.onPick,
    required this.isScanning,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Card(
            elevation: 4,
            shadowColor: theme.colorScheme.shadow.withOpacity(0.08),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.15),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated floating folder icon
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeInOutSine,
                    builder: (context, value, child) {
                      final offset = 8.0 * (1.0 - (value - 0.5).abs() * 2);
                      return Transform.translate(
                        offset: Offset(0, -offset),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary,
                                theme.colorScheme.primary.withRed(150),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.folder_open_rounded,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Text(
                    t.get('app_title'),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    t.get('select_folder'),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 36),
                  FilledButton.icon(
                    onPressed: isScanning ? null : onPick,
                    icon: const Icon(Icons.add_circle_outline_rounded),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        isScanning ? t.get('scanning') : t.get('scan_folder'),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingOverlay extends StatelessWidget {
  final String message;

  const _LoadingOverlay({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Elegant animated pulsing loader
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.2),
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOutSine,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
