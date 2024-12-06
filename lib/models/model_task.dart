import 'package:cloud_firestore/cloud_firestore.dart';

class ModelTask {
  String titleTask;
  String descriptionTask;
  String? assigner;
  String? workspaceID;
  Timestamp? due;
  Timestamp? startTime;
  final Timestamp createAt;
  final String uid;
  // final String? idTask;

  ModelTask({
    required this.createAt,
    required this.titleTask,
    required this.descriptionTask,
    required this.uid,
    this.due,
    this.assigner,
    this.workspaceID,
    this.startTime,
    // this.idTask,
  });

  Map<String, dynamic> ToMap() {
    // return (idTask == null)
    //     ? {
    //         "title": titleTask,
    //         "description": descriptionTask,
    //         "uid": uid,
    //         "createAt": createAt,
    //         "due": due
    //       }
    //     : {
    //         "title": titleTask,
    //         "description": descriptionTask,
    //         "uid": uid,
    //         "idTask": idTask,
    //         "createAt": createAt,
    //         "due": due
    //       };
    return {
      "title": titleTask,
      "description": descriptionTask,
      "uid": uid,
      "assigner": assigner,
      "workspaceID": workspaceID,
      "createAt": createAt,
      "due": due,
      "startTime": startTime,
    };
  }
}
