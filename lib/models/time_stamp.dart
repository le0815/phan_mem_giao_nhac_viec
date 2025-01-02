import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

class TimestampAdapter extends TypeAdapter<Timestamp> {
  @override
  final typeId = 16;

  @override
  Timestamp read(BinaryReader reader) {
    final micros = reader.readInt();
    return Timestamp.fromMicrosecondsSinceEpoch(micros);
  }

  @override
  void write(BinaryWriter writer, Timestamp obj) {
    writer.writeInt(obj.microsecondsSinceEpoch);
  }
}
