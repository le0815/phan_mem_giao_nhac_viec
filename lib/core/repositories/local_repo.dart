import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phan_mem_giao_nhac_viec/core/constraint/constraint.dart';
import 'package:phan_mem_giao_nhac_viec/features/message/repositories/message_local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/repositories/task_local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/services/database/database_service.dart';

class LocalRepo {
  static final LocalRepo instance = LocalRepo._();
  late final Box chatHiveBox;
  late final Box taskHiveBox;
  late final Box workspaceHiveBox;
  late final Box userSettingHiveBox;
  late final Box userHiveBox;

  LocalRepo._();

  @pragma('vm:entry-point')
  Future openAllBoxes() async {
    chatHiveBox = await Hive.openBox(HiveBoxName.chatHiveBox);
    taskHiveBox = await Hive.openBox(HiveBoxName.taskHiveBox);
    workspaceHiveBox = await Hive.openBox(HiveBoxName.workspaceHiveBox);
    userSettingHiveBox = await Hive.openBox(HiveBoxName.userSettingHiveBox);
    userHiveBox = await Hive.openBox(HiveBoxName.userHiveBox);
  }

  saveUserSetting({required Map userSetting}) {
    // save langue preference
    log("saving user setting");
    userSettingHiveBox.putAll(userSetting);
  }

  syncAllData() async {
    log("syncing all data from firebase");
    // clear all previous data
    await clearAllData();
    // load chat data
    MessageLocalRepo.instance.syncData();
    // load task data
    TaskLocalRepo.instance.syncData();
    // load workspace data
    // workspaceHiveBox.putAll(data["workspace"]);
  }

  syncData({required String syncType}) async {
    log("syncing $syncType data from firebase");
    switch (syncType) {
      case SyncTypes.syncTask:
        // load task data
        TaskLocalRepo.instance.syncData();
        break;
      case SyncTypes.syncMessage:
        // load chat data
        MessageLocalRepo.instance.syncData();
        break;
      case SyncTypes.syncWorkSpace:
        // // get data from database
        // var data = await WorkspaceService.instance
        //     .syncWorkspaceData(currentUID: currentUID);
        // // clear the previous data
        // await workspaceHiveBox.clear();
        // // sync data
        // workspaceHiveBox.putAll(data);
        break;
      default:
    }
  }

  clearAllData() async {
    await chatHiveBox.clear();
    await taskHiveBox.clear();
    await workspaceHiveBox.clear();
  }
}
