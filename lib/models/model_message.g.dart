// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelMessageAdapter extends TypeAdapter<ModelMessage> {
  @override
  final int typeId = 2;

  @override
  ModelMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelMessage(
      message: fields[1] as String,
      timeSend: fields[2] as Timestamp,
      senderUID: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ModelMessage obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.timeSend)
      ..writeByte(5)
      ..write(obj.senderUID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
