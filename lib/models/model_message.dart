import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part "model_message.g.dart";

@HiveType(typeId: 2)
class ModelMessage {
  @HiveField(1)
  final String message;
  @HiveField(2)
  final Timestamp timeSend;
  // @HiveField(3)
  // final String chatCollectionID;
  // @HiveField(4)
  // final String messageCollection;
  @HiveField(5)
  final String senderUID;

  ModelMessage({
    required this.message,
    // required this.chatCollectionID,
    // required this.messageCollection,
    required this.timeSend,
    required this.senderUID,
  });

  factory ModelMessage.fromMap(Map object) {
    return ModelMessage(
        message: object["message"],
        // chatCollectionID: object["chatCollectionID"],
        // messageCollection: object["messageCollection"],
        timeSend: object["timeSend"],
        senderUID: object["senderUID"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "timeSend": timeSend,
      "senderUID": senderUID,
    };
  }
}
