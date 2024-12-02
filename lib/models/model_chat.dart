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

  Map<String, dynamic> toMap() {
    return {
      "chatName": chatName,
      "members": members,
      "timeUpdate": timeUpdate,
    };
  }
}
