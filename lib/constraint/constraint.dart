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

Map myTaskColor = {
  MyTaskState.pending.index: Colors.yellow,
  MyTaskState.inProgress.index: Colors.blue,
  MyTaskState.completed.index: Colors.green,
  MyTaskState.overDue.index: Colors.red,
};
Map myDateTimeException = {
  0: "date time was not set",
  1: "select time less than current time",
  2: "due must be greater than start time"
};
