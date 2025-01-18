import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/core/constraint/constraint.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/model/task_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/repositories/task_remote_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/model/user_model.dart';
import 'package:phan_mem_giao_nhac_viec/services/chat/chat_service.dart';
import 'package:phan_mem_giao_nhac_viec/services/workspace/workspace_service.dart';

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

  Future getAllDataFromUID() async {
    var currentUID = FirebaseAuth.instance.currentUser!.uid;
    var result = {};
    // get all task data
    var taskData = await TaskRemoteRepo.instance.GetTaskFromDb();
    result["task"] = taskData;

    // get chat data
    var chatData =
        await ChatService.instance.syncChatData(currentUID: currentUID);

    result["chat"] = chatData;

    // get workspace data
    result["workspace"] = await WorkspaceService.instance
        .syncWorkspaceData(currentUID: currentUID);

    return result;
    // log("sync data: $result");
  }

  // get all task
  taskClassification({required Map<dynamic, dynamic> data}) {
    Map result = {};
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
    data.forEach(
      (key, value) {
        var modelTask = TaskModel.fromMap(value);
        if (result[modelTask.state] != null) {
          result[modelTask.state].addAll({key: modelTask});
        } else {
          result[modelTask.state] = {key: modelTask};
        }
      },
    );
    return result;
  }

  // taskClassification(ModelTask modelTask) {
  //   // pending task
  //   if (modelTask.state == MyTaskState.pending.name) {
  //     return {modelTask.state: modelTask};
  //   }
  //   // inProgress task
  //   if (modelTask.state == MyTaskState.inProgress.name) {
  //     return {modelTask.state: modelTask};
  //   }
  //   // completed task
  //   if (modelTask.state == MyTaskState.completed.name) {
  //     return {modelTask.state: modelTask};
  //   }
  //   // overDue task
  //   if (modelTask.state == MyTaskState.overDue.name) {
  //     return {modelTask.state: modelTask};
  //   }
  // }

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

  Future<UserModel> getUserByUID(String uid) async {
    var result =
        await _firebaseFirestore.collection(_userCollectionPath).doc(uid).get();
    return UserModel(
      email: result.data()!["email"],
      userName: result.data()!["userName"],
      uid: result.data()!["uid"],
      fcm: result.data()!["fcm"],
    );
  }
}
