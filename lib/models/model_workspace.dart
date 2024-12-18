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

  factory ModelWorkspace.fromMap(Map<String, dynamic> object) {
    return ModelWorkspace(
      createAt: object["createAt"],
      workspaceName: object["workspaceName"],
      members: object["members"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "workspaceName": workspaceName,
      "createAt": createAt,
      "members": members
    };
  }
}
