import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/constraint/constraint.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_task.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_user.dart';

class DatabaseService extends ChangeNotifier {
  static final DatabaseService instance = DatabaseService._();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  DatabaseService._();
  final String _userCollectionPath = "User";
  final _result = {};
  get result => _result;

  searchUser(String searchPhrase) async {
    // clear the previous result
    _result.clear();

    var result = await _firebaseFirestore
        .collection(_userCollectionPath)
        .where("userName", isEqualTo: searchPhrase)
        .get();

    for (var element in result.docs) {
      _result[_result.length] = element;
      log("data: $element");
    }
    notifyListeners();
  }

  // get all task
  Future<Map> GetAllTask({required String uid}) async {
    var result = await _firebaseFirestore
        .collection("Task")
        .where("uid", isEqualTo: uid)
        .get();
    Map data = {};

    // classification state of task by group
    // processed data will be like this
    // {
    //   taskState1: {
    //     docIDTask1: modelTask1,
    //     docIDTask2: modelTask2,
    //     ....
    //   }
    //   taskState2: {
    //     docIDTask3: modelTask3,
    //     docIDTask4: modelTask4,
    //     ....
    //   }
    // }
    for (var element in result.docs) {
      var tempTask = ModelTask.fromMap(element.data());
      if (data[tempTask.state] != null) {
        data[tempTask.state].addAll({element.id: tempTask});
      } else {
        data[tempTask.state] = {element.id: tempTask};
      }
    }
    return data;
  }

  taskClassification(ModelTask modelTask) {
    // pending task
    if (modelTask.state == MyTaskState.pending.name) {
      return {modelTask.state: modelTask};
    }
    // inProgress task
    if (modelTask.state == MyTaskState.inProgress.name) {
      return {modelTask.state: modelTask};
    }
    // completed task
    if (modelTask.state == MyTaskState.completed.name) {
      return {modelTask.state: modelTask};
    }
    // overDue task
    if (modelTask.state == MyTaskState.overDue.name) {
      return {modelTask.state: modelTask};
    }
  }

  // get task
  Future<Map> GetTasksFromWorkspace(String workspaceID) async {
    // get task of current user by uid
    var data = await _firebaseFirestore
        .collection('Task')
        .where("workspaceID", isEqualTo: workspaceID)
        .get();

    var result = {};
    for (var element in data.docs) {
      result[result.length] = element;
      log("data: $element");
    }
    return result;
  }

  Future<ModelUser> getUserByUID(String uid) async {
    var result =
        await _firebaseFirestore.collection(_userCollectionPath).doc(uid).get();
    return ModelUser(
      email: result.data()!["email"],
      userName: result.data()!["userName"],
      uid: result.data()!["uid"],
      fcm: result.data()!["fcm"],
    );
  }
}
