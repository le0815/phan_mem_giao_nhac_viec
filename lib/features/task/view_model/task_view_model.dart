import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:phan_mem_giao_nhac_viec/core/constraint/constraint.dart';
import 'package:phan_mem_giao_nhac_viec/core/services/background_service.dart';
import 'package:phan_mem_giao_nhac_viec/core/services/notification_service.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/model/task_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/repositories/task_local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/repositories/task_remote_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/model/user_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/repository/user_local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/repository/user_remote_repo.dart';
import 'package:phan_mem_giao_nhac_viec/main.dart';

class TaskViewModel extends ChangeNotifier {
  static final TaskViewModel instance = TaskViewModel._();

  List<UserModel> _searchMemberResult = [];
  List<UserModel> get searchMemberResult => _searchMemberResult;

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  TaskViewModel._();

  changeSelectedMemberState({required int currentIndex}) {
    var currentState = workspaceSectionGlobalKey.currentState!;
    // change selected state
    currentState.memberSelectedState[currentIndex] =
        !currentState.memberSelectedState[currentIndex];

    // turn off the other 'on' selected state
    for (var i = 0; i < currentState.memberSelectedState.length; i++) {
      if (i == currentIndex) {
        continue;
      }
      if (currentState.memberSelectedState[i] == true) {
        currentState.memberSelectedState[i] = false;
      }
    }
  }

  searchMember({required String searchPhrase}) {
    var currentState = workspaceSectionGlobalKey.currentState!;

    if (searchPhrase.isEmpty) {
      _searchMemberResult = currentState.widget.memberList;
      notifyListeners();
      return;
    }

    _searchMemberResult = currentState.widget.memberList
        .where(
          (element) => element.userName.contains(searchPhrase),
        )
        .toList();
    notifyListeners();
  }

  removeTask({required taskID}) async {
    try {
      // sync data to remote repo
      await TaskRemoteRepo.instance.RemoveTaskFromDb(taskID);
      // sync new data in hive
      syncData();
    } catch (e) {
      log("error while remove task: ${e.toString()}");
      rethrow;
    }
  }

  syncData() async {
    await TaskLocalRepo.instance.syncData();
  }

  Map<String, TaskModel> getTaskByDay({required DateTime currentDay}) {
    return TaskLocalRepo.instance.getTaskByDay(currentDay: currentDay);
  }

  dateTimeValidate({DateTime? startTime, DateTime? due}) {
    if (startTime == null || due == null) {
      return [startTime, due];
    }
    // selected time must be greater than or equal to the current time
    if (startTime.compareTo(DateTime.now()) == -1 ||
        due.compareTo(DateTime.now()) == -1) {
      log("Selected time must be equal or greater than current time");

      throw (myDateTimeException[1].toString());
    }

    // if startTime > due => show error and reselect
    if (startTime.compareTo(due) == 1) {
      log("Start time must be equal or greater than end time");

      throw (myDateTimeException[2].toString());
    }

    return [startTime.millisecondsSinceEpoch, due.millisecondsSinceEpoch];
  }

  editTask({
    required String taskID,
    required TaskModel taskModel,
    required bool isWorkspace,
    required BuildContext context,
    String? newTitle,
    String? newDescription,
    int? newStartTime,
    int? newDue,
    String? assigneeID,
  }) async {
    // update new data to model
    if (newTitle != null) {
      taskModel.title = newTitle;
    }
    if (newDescription != null) {
      taskModel.description = newDescription;
    }

    if (newStartTime != null) {
      taskModel.startTime = newStartTime;
      taskModel.due = newDue;
    }

    if (assigneeID != null) {
      taskModel.uid = assigneeID;
    }

    // update timeUpdate
    taskModel.timeUpdate = DateTime.now().millisecondsSinceEpoch;

    await TaskRemoteRepo.instance.UpdateTaskToDb(taskID, taskModel);

    if (isWorkspace) {
      // send to assignees
      UserModel modelMember = UserModel.fromMap(
          await UserLocalRepo.instance.getModelUser(uid: assigneeID!));
      NotificationService.instance.sendNotification(
          receiverToken: modelMember.fcm,
          title: AppLocalizations.of(context)!
              .yourWorkspaceTaskWasEdited(taskModel.title),
          payload: {
            "notificationType": "remote",
            "0": SyncTypes.syncTask,
          });
      await TaskLocalRepo.instance.syncData();
    } else {
      await TaskLocalRepo.instance.syncData();
    }
    // update schedule alarm
    BackgroundService.instance.setScheduleAlarm();
  }

  createTask({
    required String uid,
    required String title,
    required String description,
    required int? startTime,
    required int? due,
    required bool? isWorkspace,
    String? assigneeUID,
    String? workspaceID,
  }) async {
    if (isWorkspace == true && assigneeUID == null) {
      throw "Assignee must be selected!";
    }

    int createAt = DateTime.now().millisecondsSinceEpoch;
    int timeUpdate = createAt;
    String state = startTime == null
        ? MyTaskState.inProgress.name
        : MyTaskState.pending.name;
    TaskModel taskModel;
    if (isWorkspace == true) {
      taskModel = TaskModel(
        createAt: createAt,
        title: title,
        description: description,
        state: state,
        timeUpdate: timeUpdate,
        assigner: uid,
        uid: assigneeUID!,
        startTime: startTime,
        due: due,
        workspaceID: workspaceID,
      );
    } else {
      taskModel = TaskModel(
        createAt: createAt,
        title: title,
        description: description,
        uid: uid,
        state: state,
        timeUpdate: timeUpdate,
        startTime: startTime,
        due: due,
      );
    }

    await TaskRemoteRepo.instance.AddTaskToDb(taskModel);

    // if is workspace mode -> send notifi to trigger update task on member device
    if (isWorkspace == true) {
      UserModel modelMember = UserModel.fromMap(
        UserLocalRepo.instance.getModelUser(uid: assigneeUID!),
      );
      NotificationService.instance.sendNotification(
          receiverToken: modelMember.fcm,
          title: "You was assigned a new task!",
          payload: {
            "notificationType": "remote",
            "0": SyncTypes.syncTask,
          });
    }

    // sync data
    await TaskLocalRepo.instance.syncData();
    // create alarm for the task
    BackgroundService.instance.setScheduleAlarm();
  }
}
