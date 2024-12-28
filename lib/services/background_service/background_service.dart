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

  syncData(String type) {
    log("sync $type data in background");
    HiveBoxes.instance.syncData(syncType: type);
    log("sync $type data finished");
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
