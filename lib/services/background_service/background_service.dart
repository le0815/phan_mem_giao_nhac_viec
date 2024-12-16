import 'dart:developer';

import 'package:phan_mem_giao_nhac_viec/services/notification_service/notification_service.dart';
import 'package:workmanager/workmanager.dart';

class BackgroundService {
  static final BackgroundService instance = BackgroundService._();

  BackgroundService._();

  testBackgroundTask() async {
    await NotificationService.instance
        .showNotify(id: 0, title: "message from background service");
  }
}
