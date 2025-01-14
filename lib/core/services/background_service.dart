import 'dart:convert';
import 'dart:developer';

import 'package:phan_mem_giao_nhac_viec/features/task/model/task_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/repositories/task_local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/repositories/task_remote_repo.dart';
import 'package:phan_mem_giao_nhac_viec/core/services/notification_service.dart';

import '../constraint/constraint.dart';

class BackgroundService {
  static final BackgroundService instance = BackgroundService._();

  BackgroundService._();
  @pragma("vm:entry-point")
  Future<void> syncData(String type) async {
    log("sync $type data in background");
    // await HiveBoxes.instance.syncData(syncType: type);
    log("sync $type data finished");
  }

  setScheduleAlarm() async {
    log("setting schedule alarm");
    var taskHiveBox = TaskLocalRepo.instance.taskHiveBox.toMap();
    NotificationService notificationService = NotificationService.instance;

    // clear all previous schedule alarm first
    await notificationService.clearAllScheduleAlarm();
    // add schedule alarm for task
    taskHiveBox.forEach(
      (key, value) {
        TaskModel modelTask = TaskModel.fromMap(value);
        // pass if state of the task is completed
        if (modelTask.state == MyTaskState.completed.name) {
          return;
        }
        if (modelTask.startTime != null) {
          // set alarm for start state
          notificationService.createScheduleNotification(
            title: "your ${modelTask.title} task is start",
            payload: {
              "notificationType": "schedule",
              "taskState": MyTaskState.inProgress.name,
              "idTask": key,
              "modelTask": jsonEncode(value),
            },
            time: DateTime.fromMillisecondsSinceEpoch(modelTask.startTime!),
          );

          // set alarm for due state
          notificationService.createScheduleNotification(
            title: "your ${modelTask.title} task is due!",
            payload: {
              "notificationType": "schedule",
              "taskState": MyTaskState.overDue.name,
              "idTask": key,
              "modelTask": jsonEncode(value),
            },
            time: DateTime.fromMillisecondsSinceEpoch(modelTask.due!),
          );
        }
      },
    );
  }

  updateTaskState(Map payload) async {
    // decode string to map cause payload["modelTask"] is String datatype
    var decodedModelTask = json.decode(payload["modelTask"]);
    TaskModel modelTask = TaskModel.fromMap(decodedModelTask);
    // update task state
    var idTask = payload["idTask"];
    modelTask.state = payload["taskState"];
    TaskLocalRepo.instance.taskHiveBox.put(idTask, modelTask.ToMap());
    // update task to database
    TaskRemoteRepo.instance.UpdateTaskToDb(idTask, modelTask);
  }
}
