import 'package:cloud_firestore/cloud_firestore.dart';

class ModelWorkspace {
  final String workspaceName;
  final Timestamp createAt;
  final List members;

  ModelWorkspace({
    required this.createAt,
    required this.workspaceName,
    required this.members,
  });

  Map<String, dynamic> toMap() {
    return {
      "workspaceName": workspaceName,
      "createAt": createAt,
      "members": members
    };
  }
}
