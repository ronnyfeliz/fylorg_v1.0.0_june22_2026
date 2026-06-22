// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organize_rule.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrganizeRuleAdapter extends TypeAdapter<OrganizeRule> {
  @override
  final typeId = 0;

  @override
  OrganizeRule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrganizeRule(
      categoryName: fields[0] as String,
      extensions: (fields[1] as List).cast<String>(),
      customFolderName: fields[2] as String?,
      order: (fields[3] as num).toInt(),
      categoryKey: fields[4] == null ? '' : fields[4] as String,
      isEnabled: fields[5] == null ? true : fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, OrganizeRule obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.categoryName)
      ..writeByte(1)
      ..write(obj.extensions)
      ..writeByte(2)
      ..write(obj.customFolderName)
      ..writeByte(3)
      ..write(obj.order)
      ..writeByte(4)
      ..write(obj.categoryKey)
      ..writeByte(5)
      ..write(obj.isEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrganizeRuleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
