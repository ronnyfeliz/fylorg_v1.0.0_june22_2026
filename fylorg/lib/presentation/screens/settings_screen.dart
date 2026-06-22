import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/app_translations.dart';
import '../../data/providers/locale_provider.dart';
import '../../data/providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  final bool isTab;
  const SettingsScreen({super.key, this.isTab = false});

  static const _languages = [
    ('es', 'spanish', '🇪🇸'),
    ('en', 'english', '🇺🇸'),
    ('it', 'italian', '🇮🇹'),
    ('ru', 'russian', '🇷🇺'),
    ('ja', 'japanese', '🇯🇵'),
    ('zh', 'chinese', '🇨🇳'),
    ('pt', 'portuguese', '🇵🇹'),
    ('fr', 'french', '🇫🇷'),
    ('ko', 'korean', '🇰🇷'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppTranslations.fromLocale(
      Localizations.localeOf(context).toString(),
    );
    final theme = Theme.of(context);
    final currentLocale = ref.watch(localeProvider);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.get('settings')),
        automaticallyImplyLeading: !isTab,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          // Section: General Settings
          _buildSectionHeader(theme, t.get('settings')),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SwitchListTile(
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.folder_copy_outlined,
                    color: theme.colorScheme.primary,
                  ),
                ),
                title: Text(
                  t.get('subfolder_by_ext'),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    settings.subfolderByExt
                        ? t.get('subfolder_example')
                        : t.get('subfolder_flat'),
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ),
                value: settings.subfolderByExt,
                onChanged: (_) =>
                    ref.read(settingsProvider.notifier).toggleSubfolderByExt(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Section: Language Settings
          _buildSectionHeader(theme, t.get('language')),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: _languages.map((lang) {
                  final isSelected = currentLocale.languageCode == lang.$1;
                  return RadioListTile<String>(
                    secondary: Text(lang.$3, style: const TextStyle(fontSize: 20)),
                    title: Text(
                      t.get(lang.$2),
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                    value: lang.$1,
                    groupValue: currentLocale.languageCode,
                    onChanged: (v) =>
                        ref.read(localeProvider.notifier).setLocale(v!),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Section: Application Information
          _buildSectionHeader(theme, t.get('app_info')),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
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
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fylorg',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              t.get('app_desc'),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.55),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(Icons.person_outline_rounded, t.get('developer'), 'Innovatech', theme),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.email_outlined, t.get('support'), 'innovatech.1801@gmail.com', theme),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.calendar_month_outlined, t.get('release_date'), '21/05/2026', theme),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.update_rounded, t.get('update_date'), '21/06/2026', theme),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.info_outline_rounded, t.get('version'), '1.0', theme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, ThemeData theme) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.onSurface.withOpacity(0.4),
        ),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: theme.colorScheme.onSurface.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
