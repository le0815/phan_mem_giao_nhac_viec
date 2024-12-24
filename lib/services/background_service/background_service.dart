import 'dart:developer';

import 'package:phan_mem_giao_nhac_viec/services/task/task_service.dart';
import 'package:workmanager/workmanager.dart';

class BackgroundService {
  static final BackgroundService instance = BackgroundService._();

  BackgroundService._();

  syncData() async {
    // get task data from firebase
    // var tasksData = await TaskService.instance.GetTaskByDay(DateTime.now());
  }
}
