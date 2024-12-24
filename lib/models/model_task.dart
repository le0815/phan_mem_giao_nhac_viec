import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part "model_task.g.dart";

@HiveType(typeId: 3)
class ModelTask {
  @HiveField(0)
  String title;
  @HiveField(1)
  String description;
  @HiveField(2)
  String state;
  @HiveField(3)
  String? assigner;
  @HiveField(4)
  String? workspaceID;
  @HiveField(5)
  Timestamp? due;
  @HiveField(6)
  Timestamp? startTime;
  @HiveField(7)
  Timestamp createAt;
  @HiveField(8)
  String uid;
  @HiveField(9)
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
