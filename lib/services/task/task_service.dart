import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_task.dart';

class TaskService extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final _result = {};

  Map get result => _result;

  // add task
  Future<void> AddTaskToDb(ModelTask task) async {
    try {
      await _firebaseFirestore.collection("Task").add(task.ToMap());
    } catch (e) {
      log("err while uploading task: $e");
      throw Exception(e);
    }
  }

  // get task
  Future<void> GetTaskFromDb() async {
    try {
      // clear previous result
      _result.clear();

      // get task of current user by uid
      var data = await _firebaseFirestore
          .collection('Task')
          .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      for (var element in data.docs) {
        _result[_result.length] = element.data();
        log("data: ${element.data()}");
      }
      notifyListeners();
      log("task data: $_result");
    } catch (e) {
      log("error while getting task from db: ${e.toString()}");
      throw Exception(e);
    }
  }
  // delete task
}
