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

enum BackgroundTask {
  syncData,
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
