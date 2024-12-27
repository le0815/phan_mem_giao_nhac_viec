import 'package:flutter/material.dart';

enum MyWorkspaceRole {
  owner,
  member,
}

enum MyTaskState {
  pending,
  inProgress,
  completed,
  overDue,
}

class BackgroundTaskName {
  static const String syncTask = "syncTask";
  static const String sendDataFromIsolate = "sendDataFromIsolate";
}

class SyncTypes {
  static const String syncTask = "syncTask";
  static const String syncMessage = "syncMessage";
  static const String syncWorkSpace = "syncWorkSpace";
}

class HiveBoxName {
  static const String chatHiveBox = "chatHiveBox";
  static const String messageHiveBox = "messageHiveBox";
  static const String taskHiveBox = "taskHiveBox";
  static const String userHiveBox = "userHiveBox";
  static const String workspaceHiveBox = "workspaceHiveBox";
  static const String memberDetailHiveBox = "memberDetailHiveBox";
}

Map myTaskColor = {
  MyTaskState.pending.name: Colors.yellow,
  MyTaskState.inProgress.name: Colors.blue,
  MyTaskState.completed.name: Colors.green,
  MyTaskState.overDue.name: Colors.red,
};
Map myDateTimeException = {
  0: "date time was not set",
  1: "select time less than current time",
  2: "due must be greater than start time"
};
