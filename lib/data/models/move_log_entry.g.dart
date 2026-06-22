// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'move_log_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MoveLogEntryAdapter extends TypeAdapter<MoveLogEntry> {
  @override
  final typeId = 1;

  @override
  MoveLogEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MoveLogEntry(
      originalPath: fields[0] as String,
      destinationPath: fields[1] as String,
      wasRenamed: fields[2] as bool,
      timestamp: fields[3] as DateTime,
      sessionId: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MoveLogEntry obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.originalPath)
      ..writeByte(1)
      ..write(obj.destinationPath)
      ..writeByte(2)
      ..write(obj.wasRenamed)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.sessionId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoveLogEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
