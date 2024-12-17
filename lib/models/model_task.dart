import 'package:cloud_firestore/cloud_firestore.dart';

class ModelTask {
  String title;
  String description;
  String state;
  String? assigner;
  String? workspaceID;
  Timestamp? due;
  Timestamp? startTime;
  Timestamp createAt;
  String uid;
  Timestamp timeUpdate;
  // final String? idTask;

  ModelTask({
    required this.createAt,
    required this.title,
    required this.description,
    required this.uid,
    required this.state,
    required this.timeUpdate,
    this.due,
    this.assigner,
    this.workspaceID,
    this.startTime,
    // this.idTask,
  });

  factory ModelTask.fromMap(Map<String, dynamic> object) {
    return ModelTask(
      title: object["title"],
      description: object["description"],
      assigner: object["assigner"],
      workspaceID: object["workspaceID"],
      due: object["due"],
      startTime: object["startTime"],
      createAt: object["createAt"],
      uid: object["uid"],
      state: object["state"],
      timeUpdate: object["timeUpdate"],
    );
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
      "state": state,
      "timeUpdate": timeUpdate,
    };
  }
}
