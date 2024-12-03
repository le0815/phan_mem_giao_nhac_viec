import 'package:cloud_firestore/cloud_firestore.dart';

class ModelWorkspace {
  final String workspaceName;
  final Timestamp createAt;

  ModelWorkspace({
    required this.createAt,
    required this.workspaceName,
  });

  Map<String, dynamic> toMap() {
    return {
      "workspaceName": workspaceName,
      "createAt": createAt,
    };
  }
}
