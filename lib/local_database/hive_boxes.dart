import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_member_detail.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_message.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_task.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_user.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_workspace.dart';

import '../constraint/constraint.dart';
import '../models/model_chat.dart';

class HiveBoxes {
  static final HiveBoxes instance = HiveBoxes._();
  late final Box chatHiveBox;
  // late final Box messageHiveBox;
  late final Box taskHiveBox;
  late final Box userHiveBox;
  late final Box workspaceHiveBox;
  // late final Box memberDetailHiveBox;

  HiveBoxes._();

  registerAllAdapters() {
    Hive.registerAdapter(ModelChatAdapter());
    Hive.registerAdapter(ModelMessageAdapter());
    Hive.registerAdapter(ModelTaskAdapter());
    Hive.registerAdapter(ModelUserAdapter());
    Hive.registerAdapter(ModelWorkspaceAdapter());
    Hive.registerAdapter(ModelMemberDetailAdapter());
  }

  openAllBoxes() async {
    chatHiveBox = await Hive.openBox(HiveBoxName.chatHiveBox);
    // messageHiveBox =
    //     await Hive.openBox<ModelMessage>(HiveBoxName.messageHiveBox);
    taskHiveBox = await Hive.openBox(HiveBoxName.taskHiveBox);
    userHiveBox = await Hive.openBox<ModelUser>(HiveBoxName.userHiveBox);
    workspaceHiveBox = await Hive.openBox(HiveBoxName.workspaceHiveBox);
    // memberDetailHiveBox =
    //     await Hive.openBox<ModelMemberDetail>(HiveBoxName.memberDetailHiveBox);
  }

  syncData(Map data) {
    // load chat data
    chatHiveBox.putAll(data["chat"]);
    // load task data
    taskHiveBox.putAll(data["task"]);
    // load workspace data
    workspaceHiveBox.putAll(data["workspace"]);

    log("hive: ${taskHiveBox.toMap()}");
  }
}
