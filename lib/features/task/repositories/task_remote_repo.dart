import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/model/task_model.dart';

class TaskRemoteRepo {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  static final TaskRemoteRepo instance = TaskRemoteRepo._();
  TaskRemoteRepo._();
  // add task
  Future<void> AddTaskToDb(TaskModel task) async {
    log("uploading task to firebase");
    try {
      await _firebaseFirestore.collection("Task").add(task.ToMap());
    } catch (e) {
      log("err while uploading task: $e");
      throw Exception(e);
    }
  }

  // get task
  Future<Map> GetTaskFromDb() async {
    // get task of current user by uid
    // var data = await _firebaseFirestore
    //     .collection('Task')
    //     .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
    //     .get();

    var currentUID = FirebaseAuth.instance.currentUser!.uid;

    var data = _firebaseFirestore.collection('Task');
    // query1 to get task of current user
    // query 2 to get task was assigned by current user
    var query1 = await data.where("uid", isEqualTo: currentUID).get();
    var query2 = await data.where("assigner", isEqualTo: currentUID).get();
    var result = {};
    for (var element in query1.docs) {
      result.addAll(
        {
          element.id: element.data(),
        },
      );
    }
    for (var element in query2.docs) {
      result.addAll(
        {
          element.id: element.data(),
        },
      );
    }
    return result;
  }

  // delete task
  Future<void> RemoveTaskFromDb(String taskId) async {
    try {
      log("removing task from remote: $taskId");
      await _firebaseFirestore.collection("Task").doc(taskId).delete();
    } catch (e) {
      log("err while removing task: $e");
      throw Exception(e);
    }
  }

  // delete task
  Future<void> UpdateTaskToDb(String taskId, TaskModel modelTask) async {
    try {
      await _firebaseFirestore
          .collection("Task")
          .doc(taskId)
          .update(modelTask.ToMap());
      // reload to fetch latest update
      // GetTaskFromDb();
    } catch (e) {
      log("err while updating task: $e");
      throw Exception(e);
    }
  }

  Map<String, TaskModel> getTaskByDay(
      {required DateTime time, required Map<dynamic, dynamic> taskData}) {
    var resultByDate = <String, TaskModel>{};
    var dateOnlyCurrentTime = ConvertToDateOnly(time);

    // loop to get task with due time is bigger or equal to the current time
    taskData.forEach(
      (key, value) {
        TaskModel modelTask = TaskModel.fromMap(value);
        // if the task was not provide due time -> add
        if (modelTask.due == null) {
          resultByDate.addAll(
            {
              key: modelTask,
            },
          );
        } else {
          // convert due time to date only
          var dateOnlyDueTimeOfTask = ConvertToDateOnly(
              DateTime.fromMillisecondsSinceEpoch(modelTask.due!));
          // convert due time to date only
          var dateOnlyCreateTimeOfTask = ConvertToDateOnly(
              DateTime.fromMillisecondsSinceEpoch(modelTask.startTime!));
          // if due, create time is greater or equal than current day
          if (dateOnlyCurrentTime.compareTo(dateOnlyDueTimeOfTask) != 1 &&
              dateOnlyCurrentTime.compareTo(dateOnlyCreateTimeOfTask) != -1) {
            resultByDate.addAll(
              {
                key: modelTask,
              },
            );
          }
        }
      },
    );
    return resultByDate;
    // notifyListeners();
  }
}

DateTime ConvertToDateOnly(DateTime time) {
  return time.copyWith(
      hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
}
