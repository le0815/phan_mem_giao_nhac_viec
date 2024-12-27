// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_workspace.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelWorkspaceAdapter extends TypeAdapter<ModelWorkspace> {
  @override
  final int typeId = 0;

  @override
  ModelWorkspace read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelWorkspace(
      createAt: fields[1] as int,
      workspaceName: fields[0] as String,
      members: (fields[2] as List).cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, ModelWorkspace obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.workspaceName)
      ..writeByte(1)
      ..write(obj.createAt)
      ..writeByte(2)
      ..write(obj.members);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelWorkspaceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
