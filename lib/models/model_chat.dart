import 'package:cloud_firestore/cloud_firestore.dart';

class ModelChat {
  final String chatName;
  final List members;
  final Timestamp timeUpdate;

  ModelChat({
    required this.chatName,
    required this.members,
    required this.timeUpdate,
  });

  factory ModelChat.fromMap(Map<String, dynamic> object) {
    return ModelChat(
        chatName: object["chatName"],
        members: object["members"],
        timeUpdate: object["timeUpdate"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "chatName": chatName,
      "members": members,
      "timeUpdate": timeUpdate,
    };
  }
}
