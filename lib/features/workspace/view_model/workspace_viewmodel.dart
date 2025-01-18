import 'dart:developer';

import 'package:calendar_view/calendar_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:phan_mem_giao_nhac_viec/core/constraint/constraint.dart';
import 'package:phan_mem_giao_nhac_viec/core/services/notification_service.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/model/task_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/repositories/task_local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/repositories/task_remote_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/model/user_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/repository/user_local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/repository/user_remote_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/workspace/models/model_workspace.dart';
import 'package:phan_mem_giao_nhac_viec/features/workspace/repositories/workspace_local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/workspace/repositories/workspace_remote_repo.dart';
import 'package:phan_mem_giao_nhac_viec/main.dart';

class WorkspaceViewModel extends ChangeNotifier {
  static final WorkspaceViewModel instance = WorkspaceViewModel._();
  WorkspaceViewModel._();

  final currentUID = FirebaseAuth.instance.currentUser!.uid;
  Map _searchResult = {};
  Map get searchResult => _searchResult;

  getModelUserMembers() {
    var currentState = detailWorkspacePageGlobalKey.currentState!;
    currentState.widget.modelDetailMembers.forEach(
      (key, value) {
        UserModel userModel =
            UserModel.fromMap(UserLocalRepo.instance.getModelUser(uid: key));
        currentState.modelUserMember.add(userModel);
      },
    );
  }

  searchUserByPhrase({required String searchPhrase}) async {
    _searchResult = await UserRemoteRepo.instance
        .searchUserByPhrase(searchPhrase: searchPhrase);
    log("search result: $_searchResult");
    notifyListeners();
  }

  removeTask({required String taskID}) async {
    // remove task from firebase
    await TaskRemoteRepo.instance.RemoveTaskFromDb(taskID);
    // sync task data
    TaskLocalRepo.instance.syncData();
  }

  removeUser({
    required ModelWorkspace modelWorkspace,
    required String workspaceID,
    required Map membersDetail,
    required String uid,
    required UserModel userModel,
  }) async {
    await WorkspaceRemoteRepo.instance.leaveWorkspace(
      workspaceID: workspaceID,
      uid: uid,
      modelWorkspace: modelWorkspace,
      membersDetail: membersDetail,
    );

    // sync workspace data
    WorkspaceLocalRepo.instance.syncData();
    // sync task data
    TaskLocalRepo.instance.syncData();

    // send notification to user
    NotificationService.instance.sendNotification(
      receiverToken: userModel.fcm,
      title:
          "You have been removed from ${modelWorkspace.workspaceName} workspace!",
      payload: {
        "notificationType": "remote",
        "0": SyncTypes.syncWorkSpace,
      },
    );
  }

  leaveWorkspace({
    required ModelWorkspace modelWorkspace,
    required String workspaceID,
    required Map membersDetail,
    required String uid,
  }) async {
    await WorkspaceRemoteRepo.instance.leaveWorkspace(
      workspaceID: workspaceID,
      uid: uid,
      modelWorkspace: modelWorkspace,
      membersDetail: membersDetail,
    );

    // sync workspace data
    WorkspaceLocalRepo.instance.syncData();
    // sync task data
    TaskLocalRepo.instance.syncData();

    // send notification to workspace owner
    UserModel? ownerModelUser;
    membersDetail.forEach(
      (key, value) {
        if (value["role"] == MyWorkspaceRole.owner.name) {
          ownerModelUser =
              UserModel.fromMap(UserLocalRepo.instance.getModelUser(uid: key));
          return;
        }
      },
    );
    NotificationService.instance.sendNotification(
      receiverToken: ownerModelUser!.fcm,
      title: "$currentUID just left group",
      payload: {
        "notificationType": "remote",
        "0": SyncTypes.syncWorkSpace,
      },
    );
  }

  deleteWorkspace({required String workspaceID}) async {
    await WorkspaceRemoteRepo.instance.deleteWorkspace(workspaceID);
    // sync workspace data
    WorkspaceLocalRepo.instance.syncData();
    // sync task data
    TaskLocalRepo.instance.syncData();
  }

  clearAllPreviousEvents() {
    var currentState = detailWorkspacePageGlobalKey.currentState!;
    if (currentState.events.isNotEmpty) {
      currentState.calendarController!.removeAll(currentState.events);
      currentState.events.clear();
    }
  }

  addEvents({required String workspaceID}) {
    // clear previous events
    clearAllPreviousEvents();
    var currentState = detailWorkspacePageGlobalKey.currentState!;
    // get event form database
    TaskLocalRepo.instance.taskHiveBox.toMap().forEach(
      (key, value) {
        TaskModel modelTask = TaskModel.fromMap(value);
        // skip task was not in workspace
        if (modelTask.workspaceID == null) {
          return;
        }
        if (modelTask.workspaceID != workspaceID) {
          return;
        }
        CalendarEventData event;
        // if task have due
        if (modelTask.startTime != null) {
          event = CalendarEventData(
            color: myTaskColor[modelTask.state],
            title: modelTask.title,
            // startTime: value.data()["startTime"],
            date: DateTime.fromMillisecondsSinceEpoch(modelTask.startTime!),
            endDate: DateTime.fromMillisecondsSinceEpoch(modelTask.due!),
            event: {
              "modelTask": modelTask,
              "id": key,
            },
          );
        } else {
          // if task have no due
          event = CalendarEventData(
            color: myTaskColor[modelTask.state],
            title: modelTask.title,
            date: DateTime.fromMillisecondsSinceEpoch(modelTask.createAt),
            event: {
              "modelTask": modelTask,
              "id": key,
            },
          );
        }
        currentState.events.add(event);
      },
    );
    // broadcast events
    CalendarControllerProvider.of(currentState.context)
        .controller
        .addAll(currentState.events);
  }

  String getCurrentUserRole(
      {required String uid, required Map modelDetailMembers}) {
    return modelDetailMembers[currentUID]["role"];
  }

  addUserToWorkspace({
    required UserModel userModel,
    required String workspaceDocID,
    required ModelWorkspace modelWorkspace,
  }) async {
    try {
      var workspaceMembers = modelWorkspace.members;
      workspaceMembers.add(userModel.uid);

      await WorkspaceRemoteRepo.instance.addUser(
          docID: workspaceDocID,
          uid: userModel.uid,
          newMemberList: workspaceMembers);

      // sync data
      await WorkspaceLocalRepo.instance.syncData();
      getModelUserMembers();
    } on Exception catch (e) {
      throw "Error while add new user: ${e.toString()}";
    }
  }

  createWorkspace({required String workspaceName}) async {
    int createAt = DateTime.now().millisecondsSinceEpoch;
    List members = [currentUID];
    ModelWorkspace modelWorkspace = ModelWorkspace(
        createAt: createAt, workspaceName: workspaceName, members: members);
    await WorkspaceRemoteRepo.instance.createWorkspace(
        currentUID: currentUID, modelWorkspace: modelWorkspace);

    // sync data
    WorkspaceLocalRepo.instance.syncData();
  }
}
