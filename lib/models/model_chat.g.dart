// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_chat.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelChatAdapter extends TypeAdapter<ModelChat> {
  @override
  final int typeId = 1;

  @override
  ModelChat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelChat(
      chatName: fields[0] as String,
      members: (fields[1] as List).cast<dynamic>(),
      timeUpdate: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ModelChat obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.chatName)
      ..writeByte(1)
      ..write(obj.members)
      ..writeByte(2)
      ..write(obj.timeUpdate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelChatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
