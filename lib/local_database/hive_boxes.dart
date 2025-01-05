import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_member_detail.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_message.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_task.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_user.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_workspace.dart';
import 'package:phan_mem_giao_nhac_viec/services/database/database_service.dart';

import '../constraint/constraint.dart';
import '../models/model_chat.dart';
import '../models/time_stamp.dart';
import '../services/chat/chat_service.dart';
import '../services/task/task_service.dart';
import '../services/workspace/workspace_service.dart';

class HiveBoxes {
  static final HiveBoxes instance = HiveBoxes._();
  late final Box chatHiveBox;
  late final Box taskHiveBox;
  late final Box workspaceHiveBox;
  late final Box userSettingHiveBox;

  HiveBoxes._();

  @pragma('vm:entry-point')
  registerAllAdapters() {
    Hive.registerAdapter(ModelChatAdapter());
    Hive.registerAdapter(ModelMessageAdapter());
    Hive.registerAdapter(ModelTaskAdapter());
    Hive.registerAdapter(ModelUserAdapter());
    Hive.registerAdapter(ModelWorkspaceAdapter());
    Hive.registerAdapter(ModelMemberDetailAdapter());
    Hive.registerAdapter(TimestampAdapter());
  }

  @pragma('vm:entry-point')
  Future openAllBoxes() async {
    chatHiveBox = await Hive.openBox(HiveBoxName.chatHiveBox);
    taskHiveBox = await Hive.openBox(HiveBoxName.taskHiveBox);
    workspaceHiveBox = await Hive.openBox(HiveBoxName.workspaceHiveBox);
    userSettingHiveBox = await Hive.openBox(HiveBoxName.userSettingHiveBox);
  }

  saveUserSetting({required Map userSetting}) {
    // save langue preference
    log("saving user setting");
    userSettingHiveBox.putAll(userSetting);
  }

  syncAllData() async {
    log("syncing all data from firebase");
    // get data from database
    var data = await DatabaseService.instance.getAllDataFromUID();
    // clear all previous data
    await clearAllData();
    // load chat data
    chatHiveBox.putAll(data["chat"]);
    // load task data
    taskHiveBox.putAll(data["task"]);
    // load workspace data
    workspaceHiveBox.putAll(data["workspace"]);
  }

  syncData({required String syncType}) async {
    String currentUID = FirebaseAuth.instance.currentUser!.uid;
    log("syncing $syncType data from firebase");
    switch (syncType) {
      case SyncTypes.syncTask:
        // get data from database
        var data = await TaskService.instance.GetTaskFromDb();
        // clear the previous data
        await taskHiveBox.clear();
        // sync data
        taskHiveBox.putAll(data);
        break;
      case SyncTypes.syncMessage:
        // get data from database
        var data =
            await ChatService.instance.syncChatData(currentUID: currentUID);
        // clear the previous data
        await chatHiveBox.clear();
        // sync data
        chatHiveBox.putAll(data);
        break;
      case SyncTypes.syncWorkSpace:
        // get data from database
        var data = await WorkspaceService.instance
            .syncWorkspaceData(currentUID: currentUID);
        // clear the previous data
        await workspaceHiveBox.clear();
        // sync data
        workspaceHiveBox.putAll(data);
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
