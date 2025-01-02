import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part "model_workspace.g.dart";

@HiveType(typeId: 0)
class ModelWorkspace {
  @HiveField(0)
  final String workspaceName;
  @HiveField(1)
  final int createAt;
  @HiveField(2)
  final List members;

  ModelWorkspace({
    required this.createAt,
    required this.workspaceName,
    required this.members,
  });

  factory ModelWorkspace.fromMap(Map<dynamic, dynamic> object) {
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
