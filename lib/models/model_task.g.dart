// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelTaskAdapter extends TypeAdapter<ModelTask> {
  @override
  final int typeId = 3;

  @override
  ModelTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelTask(
      createAt: fields[7] as int,
      title: fields[0] as String,
      description: fields[1] as String,
      uid: fields[8] as String,
      state: fields[2] as String,
      timeUpdate: fields[9] as int,
      due: fields[5] as int?,
      assigner: fields[3] as String?,
      workspaceID: fields[4] as String?,
      startTime: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ModelTask obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.state)
      ..writeByte(3)
      ..write(obj.assigner)
      ..writeByte(4)
      ..write(obj.workspaceID)
      ..writeByte(5)
      ..write(obj.due)
      ..writeByte(6)
      ..write(obj.startTime)
      ..writeByte(7)
      ..write(obj.createAt)
      ..writeByte(8)
      ..write(obj.uid)
      ..writeByte(9)
      ..write(obj.timeUpdate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
