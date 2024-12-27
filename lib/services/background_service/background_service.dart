import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phan_mem_giao_nhac_viec/local_database/hive_boxes.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_user.dart';
import 'package:phan_mem_giao_nhac_viec/services/database/database_service.dart';

import '../../constraint/constraint.dart';
import '../task/task_service.dart';

class BackgroundService {
  static final BackgroundService instance = BackgroundService._();

  BackgroundService._();

  syncData(String type) async {
    switch (type) {
      // sync task
      case BackgroundTaskName.syncTask:
        log("fetching data from firebase");
        var syncData = await DatabaseService.instance.getAllDataFromUID();
        var taskData = syncData["task"];
        log("data fetched from firebase: $taskData");
        // clear old data
        await HiveBoxes.instance.taskHiveBox!.clear();
        // update new data
        log("loading task data into Hive");
        await HiveBoxes.instance.taskHiveBox!.putAll(taskData);
        log("task data after update: ${HiveBoxes.instance.taskHiveBox!.toMap()}");

        break;
      default:
    }
  }

  // static sendDataToMainIsolate(String portName) {
  //   final sendPort = IsolateNameServer.lookupPortByName(portName);
  //   switch (portName) {
  //     // send task data
  //     case IsolatePortName.taskData:
  //       try {
  //         // var sendPort = IsolateNameServer.lookupPortByName(portName);
  //         log("start send data from background service");
  //         sendPort!.send(HiveBoxes.instance.taskHiveBox!.toMap());
  //       } catch (e) {
  //         log("exception from send port: $e");
  //       }
  //       break;
  //     default:
  //   }
  // }
}
