import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_user.dart';

class DatabaseService extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
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

  Future<void> deleteWorkspace(String workspaceID) async {
    // get workspace doc
    var workspaceDoc =
        _firebaseFirestore.collection("Workspace").doc(workspaceID);
    var subCollection = await workspaceDoc.collection("MembersDetail").get();

    // delete sub collection first
    for (var element in subCollection.docs) {
      await workspaceDoc.collection("MembersDetail").doc(element.id).delete();
    }
    // delete workspace
    await workspaceDoc.delete();

    // delete tasks of workspace
    // get all taskID of workspace task
    var tasksID = await _firebaseFirestore
        .collection("Task")
        .where("workspaceID", isEqualTo: workspaceID)
        .get();

    // delete task
    for (var element in tasksID.docs) {
      await _firebaseFirestore.collection("Task").doc(element.id).delete();
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
