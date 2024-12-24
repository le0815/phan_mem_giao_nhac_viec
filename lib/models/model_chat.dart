import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part "model_chat.g.dart";

@HiveType(typeId: 1)
class ModelChat extends HiveObject {
  @HiveField(0)
  final String chatName;
  @HiveField(1)
  final List members;
  @HiveField(2)
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
