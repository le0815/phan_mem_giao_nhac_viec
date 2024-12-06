import 'package:cloud_firestore/cloud_firestore.dart';

class ModelTask {
  late String title;
  late String description;
  String? assigner;
  String? workspaceID;
  Timestamp? due;
  Timestamp? startTime;
  late Timestamp createAt;
  late String uid;
  // final String? idTask;

  ModelTask({
    required this.createAt,
    required this.title,
    required this.description,
    required this.uid,
    this.due,
    this.assigner,
    this.workspaceID,
    this.startTime,
    // this.idTask,
  });

  ModelTask.fromMap(Map<String, dynamic> object) {
    title = object["title"];
    description = object["description"];
    assigner = object["assigner"];
    workspaceID = object["workspaceID"];
    due = object["due"];
    startTime = object["startTime"];
    createAt = object["createAt"];
    uid = object["uid"];
  }

  Map<String, dynamic> ToMap() {
    return {
      "title": title,
      "description": description,
      "uid": uid,
      "assigner": assigner,
      "workspaceID": workspaceID,
      "createAt": createAt,
      "due": due,
      "startTime": startTime,
    };
  }
}
