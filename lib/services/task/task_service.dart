import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_task.dart';

class TaskService extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final _result = {};
  final _resultByDate = {};

  Map get result => _result;
  Map get resultByDate => _resultByDate;
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
        _result[_result.length] = element;
        log("data: $element");
      }
      // notifyListeners();
      log("task data: $_result");
    } catch (e) {
      log("error while getting task from db: ${e.toString()}");
      throw Exception(e);
    }
  }

  // delete task
  Future<void> RemoveTaskFromDb(String taskId, DateTime currentDate) async {
    try {
      await _firebaseFirestore.collection("Task").doc(taskId).delete();
      // reload to fetch latest update
      GetTaskByDay(currentDate);
    } catch (e) {
      log("err while removing task: $e");
      throw Exception(e);
    }
  }

  // delete task
  Future<void> UpdateTaskFromDb(String taskId, ModelTask modelTask) async {
    try {
      await _firebaseFirestore
          .collection("Task")
          .doc(taskId)
          .update(modelTask.ToMap());
      // reload to fetch latest update
      GetTaskFromDb();
    } catch (e) {
      log("err while updating task: $e");
      throw Exception(e);
    }
  }

  Future<void> GetTaskByDay(DateTime time) async {
    // get latest update task from db
    await GetTaskFromDb();
    // clear the previous resultByDate
    _resultByDate.clear();

    // loop for get task with createAt itself match to the current time
    for (var element in _result.values) {
      // element
      Timestamp timeCreateOfTask = element.data()["createAt"];
      // convert to date only
      var dateOnlyTimeCreateOfTask = ConvertToDateOnly(
          DateTime.fromMillisecondsSinceEpoch(
              timeCreateOfTask.millisecondsSinceEpoch));
      var dateOnlyCurrentTime = ConvertToDateOnly(time);

      if (dateOnlyCurrentTime.compareTo(dateOnlyTimeCreateOfTask) == 0) {
        _resultByDate[_resultByDate.length] = element;
      }
    }
    notifyListeners();
  }
}

DateTime ConvertToDateOnly(DateTime time) {
  return time.copyWith(
      hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
}
