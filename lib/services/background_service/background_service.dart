import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:googleapis/books/v1.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phan_mem_giao_nhac_viec/local_database/hive_boxes.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_task.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_user.dart';
import 'package:phan_mem_giao_nhac_viec/services/database/database_service.dart';
import 'package:phan_mem_giao_nhac_viec/services/notification_service/notification_service.dart';

import '../../constraint/constraint.dart';
import '../task/task_service.dart';

class BackgroundService {
  static final BackgroundService instance = BackgroundService._();

  BackgroundService._();
  @pragma("vm:entry-point")
  syncData(String type) {
    log("sync $type data in background");
    HiveBoxes.instance.syncData(syncType: type);
    log("sync $type data finished");
  }

  setScheduleAlarm() async {
    var taskHiveBox = HiveBoxes.instance.taskHiveBox.toMap();
    NotificationService notificationService = NotificationService.instance;

    // clear all previous schedule alarm first
    await notificationService.clearAllScheduleAlarm();
    // add schedule alarm for task
    taskHiveBox.forEach(
      (key, value) {
        ModelTask modelTask = ModelTask.fromMap(value);

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
}
