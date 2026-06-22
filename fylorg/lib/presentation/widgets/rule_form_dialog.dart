import 'package:flutter/material.dart';

import '../../core/l10n/app_translations.dart';
import '../../core/utils/category_localizer.dart';
import '../../data/models/organize_rule.dart';

class RuleFormDialog extends StatefulWidget {
  final OrganizeRule? existing;
  final AppTranslations translations;

  const RuleFormDialog({
    super.key,
    this.existing,
    required this.translations,
  });

  @override
  State<RuleFormDialog> createState() => _RuleFormDialogState();
}

class _RuleFormDialogState extends State<RuleFormDialog> {
  final _nameCtrl = TextEditingController();
  final _folderCtrl = TextEditingController();
  final _extCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      _nameCtrl.text = CategoryLocalizer.localizeRuleCategory(widget.existing!, context);
      _folderCtrl.text = widget.existing!.customFolderName ?? '';
      _extCtrl.text = widget.existing!.extensions.join(', ');
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _folderCtrl.dispose();
    _extCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.translations;
    final isEditing = widget.existing != null;
    return AlertDialog(
      title: Text(isEditing ? t.get('edit_rule') : t.get('new_rule')),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: t.get('category_name'),
                hintText: t.get('category_name'),
                prefixIcon: const Icon(Icons.category_outlined, size: 20),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _extCtrl,
              decoration: InputDecoration(
                labelText: t.get('extensions'),
                hintText: t.get('extensions_hint'),
                prefixIcon: const Icon(Icons.extension_outlined, size: 20),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _folderCtrl,
              decoration: InputDecoration(
                labelText: t.get('folder_name_optional'),
                hintText: t.get('folder_hint'),
                prefixIcon: const Icon(Icons.folder_open_outlined, size: 20),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.get('cancel')),
        ),
        FilledButton(
          onPressed: () {
            final name = _nameCtrl.text.trim();
            if (name.isEmpty) return;
            final extensions = _extCtrl.text
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();
            final folder = _folderCtrl.text.trim();
            final finalKey = CategoryLocalizer.getCategoryKeyForName(name);
            Navigator.pop(
              context,
              OrganizeRule(
                categoryName: name,
                extensions: extensions,
                customFolderName: folder.isEmpty ? null : folder,
                order: widget.existing?.order ?? 0,
                categoryKey: finalKey,
              ),
            );
          },
          child: Text(t.get('save')),
        ),
      ],
    );
  }
}
