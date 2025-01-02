// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_member_detail.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelMemberDetailAdapter extends TypeAdapter<ModelMemberDetail> {
  @override
  final int typeId = 5;

  @override
  ModelMemberDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelMemberDetail(
      role: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ModelMemberDetail obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.role);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelMemberDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
