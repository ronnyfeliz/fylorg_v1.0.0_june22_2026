import 'package:hive_ce/hive_ce.dart';

part 'organize_rule.g.dart';

@HiveType(typeId: 0)
class OrganizeRule {
  @HiveField(0)
  final String categoryName;

  @HiveField(1)
  final List<String> extensions;

  @HiveField(2)
  final String? customFolderName;

  @HiveField(3)
  final int order;

  @HiveField(4)
  final String categoryKey;

  @HiveField(5)
  final bool isEnabled;

  const OrganizeRule({
    required this.categoryName,
    required this.extensions,
    this.customFolderName,
    required this.order,
    this.categoryKey = '',
    this.isEnabled = true,
  });

  OrganizeRule copyWith({
    String? categoryName,
    List<String>? extensions,
    String? customFolderName,
    int? order,
    String? categoryKey,
    bool? isEnabled,
  }) =>
      OrganizeRule(
        categoryName: categoryName ?? this.categoryName,
        extensions: extensions ?? this.extensions,
        customFolderName: customFolderName ?? this.customFolderName,
        order: order ?? this.order,
        categoryKey: categoryKey ?? this.categoryKey,
        isEnabled: isEnabled ?? this.isEnabled,
      );
}
