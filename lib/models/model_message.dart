import 'package:cloud_firestore/cloud_firestore.dart';

class ModelMessage {
  final String message;
  final Timestamp timeSend;
  final String chatCollection;
  final String messageCollection;
  final String senderUID;

  ModelMessage({
    required this.message,
    required this.chatCollection,
    required this.messageCollection,
    required this.timeSend,
    required this.senderUID,
  });

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "timeSend": timeSend,
      "senderUID": senderUID,
    };
  }
}
