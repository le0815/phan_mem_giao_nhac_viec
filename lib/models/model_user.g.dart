// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelUserAdapter extends TypeAdapter<ModelUser> {
  @override
  final int typeId = 4;

  @override
  ModelUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelUser(
      email: fields[0] as String,
      userName: fields[1] as String,
      uid: fields[2] as String,
      fcm: (fields[3] as List).cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, ModelUser obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.uid)
      ..writeByte(3)
      ..write(obj.fcm);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
