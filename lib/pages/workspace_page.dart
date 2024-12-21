import 'dart:developer';

import 'package:calendar_view/calendar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_loading_indicator.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_user_tile_overview.dart';
import 'package:phan_mem_giao_nhac_viec/constraint/constraint.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_task.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_user.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_workspace.dart';
import 'package:phan_mem_giao_nhac_viec/pages/add_task.dart';
import 'package:phan_mem_giao_nhac_viec/pages/detail_task_page.dart';
import 'package:phan_mem_giao_nhac_viec/services/database/database_service.dart';
import 'package:phan_mem_giao_nhac_viec/services/notification_service/notification_service.dart';
import 'package:phan_mem_giao_nhac_viec/services/task/task_service.dart';
import 'package:phan_mem_giao_nhac_viec/services/workspace/workspace_service.dart';
import 'package:phan_mem_giao_nhac_viec/ultis/add_space.dart';
import 'package:provider/provider.dart';

import '../components/my_legend_chart.dart';

class WorkspacePage extends StatefulWidget {
  final Map workspaceData;
  final String workspaceID;

  const WorkspacePage({
    super.key,
    required this.workspaceData,
    required this.workspaceID,
  });

  @override
  State<WorkspacePage> createState() => WorkspacePageState();
}

class WorkspacePageState extends State<WorkspacePage> {
  // final event = CalendarEventData(
  //   date: DateTime.now(),
  //   title: "Project meeting",
  //   description: "Today is project meeting.",
  //   startTime: DateTime(
  //       DateTime.now().year, DateTime.now().month, DateTime.now().day, 18, 30),
  //   endTime: DateTime(
  //       DateTime.now().year, DateTime.now().month, DateTime.now().day, 22),
  // );
  ModelWorkspace? modelWorkspace;
  Map? membersDetail;
  final taskService = TaskService();
  var currentUID = FirebaseAuth.instance.currentUser!.uid;
  var currentUserRole;
  List<CalendarEventData> events = [];
  List<ModelUser> membersOfWorkspace = [];
  var calendarController;
  Future<List> getUsers() async {
    final List<ModelUser> userList = [];
    for (var element in modelWorkspace!.members) {
      var result = await DatabaseService.instance.getUserByUID(element);
      userList.add(result);
    }
    membersOfWorkspace = userList;
    return userList;
  }

  clearTaskResult() {
// clear the previous task
    if (events.isNotEmpty) {
      calendarController.removeAll(events);
      events.clear();
    }
  }

  checkCurrentUserRole() async {
    currentUserRole = membersDetail![currentUID]["role"];
  }

  getAllTasks() async {
    clearTaskResult();

    Map taskResult = await DatabaseService.instance
        .GetTasksFromWorkspace(widget.workspaceID);
    // get event form database
    taskResult.forEach(
      (key, value) {
        CalendarEventData event;
        // if task have due
        if (value.data()["startTime"] != null) {
          event = CalendarEventData(
            color: myTaskColor[value.data()["state"]],
            title: value.data()["title"],
            // startTime: value.data()["startTime"],
            date: DateTime.fromMillisecondsSinceEpoch(
                (value.data()["startTime"] as Timestamp)
                    .millisecondsSinceEpoch),
            endDate: DateTime.fromMillisecondsSinceEpoch(
                (value.data()["due"] as Timestamp).millisecondsSinceEpoch),
            event: {
              "modelTask": value.data(),
              "id": value.id,
            },
          );
        } else {
          // if task have no due
          event = CalendarEventData(
            color: myTaskColor[value.data()["state"]],
            title: value.data()["title"],
            date: DateTime.fromMillisecondsSinceEpoch(
                (value.data()["createAt"] as Timestamp).millisecondsSinceEpoch),
            event: {
              "modelTask": value.data(),
              "id": value.id,
            },
          );
        }
        events.add(event);
      },
    );
    // broadcast events
    CalendarControllerProvider.of(context).controller.addAll(events);
  }

  RemoveTaskFromDb(String taskId) async {
    try {
      await taskService.RemoveTaskFromDb(taskId);
    } catch (e) {
      if (context.mounted) {
        // show err dialog
        MyAlertDialog(
          context,
          msg: e.toString(),
          onOkay: () => Navigator.pop(context),
        );
      }
    }
  }

  leaveWorkspace({required String workspaceID, required String uid}) async {
    try {
      await WorkspaceService.instance.leaveWorkspace(
        workspaceID: workspaceID,
        uid: uid,
        modelWorkspace: modelWorkspace!,
        membersDetail: membersDetail!,
        membersOfWorkspace: membersOfWorkspace,
      );
    } catch (e) {
      // show err dialog
      MyAlertDialog(
        context,
        msg: e.toString(),
        onOkay: () => Navigator.pop(context),
      );
    }
  }

  deleteWorkspace(String workspaceID) async {
    await WorkspaceService.instance.deleteWorkspace(workspaceID);
  }

  removeUser({required String workspaceID, required String uid}) {}

  @override
  void didChangeDependencies() {
    modelWorkspace = widget.workspaceData.entries.first.value;
    membersDetail = widget.workspaceData.entries.last.value;
    calendarController = CalendarControllerProvider.of(context).controller;
    getAllTasks();
    checkCurrentUserRole();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(modelWorkspace!.workspaceName),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.menu), // Icon for the button
            onSelected: (value) {
              // Handle selected value
              if (value == 0) {
                addMemberDialog(context, modelWorkspace!.members,
                    widget.workspaceID, modelWorkspace!);
              }
              // delete workspace
              if (value == 1) {
                // show alert
                // if current use is owner -> delete workspace
                // else leave
                if (MyWorkspaceRole.values.first.name == currentUserRole) {
                  MyAlertDialog(
                    context,
                    msg: "Are you sure want to delete this workspace?",
                    onOkay: () {
                      deleteWorkspace(widget.workspaceID);
                      // close alert dialog
                      Navigator.pop(context);
                      // close workspace page
                      Navigator.pop(context);
                    },
                  );
                } else {
                  MyAlertDialog(
                    context,
                    msg: "Are you sure want to leave this workspace?",
                    onOkay: () async {
                      await leaveWorkspace(
                          workspaceID: widget.workspaceID, uid: currentUID);
                      // close alert dialog
                      Navigator.pop(context);
                      // close workspace page
                      Navigator.pop(context);
                    },
                  );
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Text('Add member'),
              ),
              // if user is owner => delete workspace
              // if user is member => leave workspace
              PopupMenuItem(
                value: 1,
                child: Text(
                  MyWorkspaceRole.values.first.name == currentUserRole
                      ? 'Delete workspace'
                      : "Leave Workspace",
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // show workspace task overview
            SizedBox(
              height: 500,
              child: MonthView(
                onEventTap: (event, date) async {
                  log("event: ${event.event as Map}");
                  // navigation to detail task page
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailTaskPage(
                        onRemove: () {
                          // show alert
                          MyAlertDialog(
                            context,
                            msg: "Are you sure want to delete this task?",
                            onOkay: () {
                              RemoveTaskFromDb((event.event as Map)["id"]);
                              // close alert dialog
                              Navigator.pop(context);
                              // switch back to right before screen
                              Navigator.pop(context);
                            },
                          );
                        },
                        modelTask: ModelTask.fromMap(
                            (event.event as Map)["modelTask"]),
                        idTask: (event.event as Map)["id"],
                        isWorkspace: true,
                        workspaceName: modelWorkspace!.workspaceName,
                        memberList: membersOfWorkspace,
                      ),
                    ),
                  );
                  // reload task overview
                  getAllTasks();
                },
                onDateLongPress: (date) async {
                  // navigation to add task page
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTask(
                        memberList: membersOfWorkspace,
                        workspaceID: widget.workspaceID,
                        isWorkspace: true,
                      ),
                    ),
                  );
                  // reload task overview
                  getAllTasks();
                  log("cell long press date: $date");
                },
              ),
            ),
            // show annotation for the calendar
            AddVerticalSpace(8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      myLegendChart(
                          annotation: "Pending", color: Colors.yellow),
                      myLegendChart(
                          annotation: "In progress", color: Colors.blue),
                    ],
                  ),
                  AddHorizontalSpace(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      myLegendChart(
                          annotation: "Completed", color: Colors.green),
                      myLegendChart(annotation: "Over due", color: Colors.red),
                    ],
                  ),
                ],
              ),
            ),
            // show members of workspace
            Container(
              height: 500,
              padding:
                  const EdgeInsets.only(top: 8, left: 12, right: 12, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text("Members",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(
                    thickness: 1,
                    color: Colors.black,
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: getUsers(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const MyLoadingIndicator();
                        }
                        if (!snapshot.hasData) {
                          return const Text("No member");
                        }

                        var result = snapshot.data;
                        log(result.toString());
                        return ListView.builder(
                          itemCount: result!.length,
                          itemBuilder: (context, index) {
                            ModelUser modelUser = result[index];
                            return MyUserTileOverview(
                              userName: modelUser.userName,
                              msg: modelUser.email,
                              onRemove: () async {
                                // remove user has the same logic as leaveWorkspace
                                await leaveWorkspace(
                                    workspaceID: widget.workspaceID,
                                    uid: modelUser.uid);

                                // reload data
                                setState(() {});
                                getAllTasks();
                              },
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  addMemberDialog(BuildContext context, List currentMemberUID,
      String workspaceID, ModelWorkspace modelWorkspace) {
    TextEditingController searchPhaseController = TextEditingController();
    final _userTileGlobalKey = GlobalKey<MyUserTileOverviewState>();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add new Chat!"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // enter user searchPhase
                Consumer<DatabaseService>(
                  builder: (context, value, child) {
                    return MyTextfield(
                      textController: searchPhaseController,
                      textFieldHint: "Search user to add",
                      prefixIcon: const Icon(Icons.search_outlined),
                      onPressed: () {
                        value.searchUser(searchPhaseController.text);
                      },
                    );
                  },
                ),
                AddVerticalSpace(10),
                // query user to add to this chat
                SizedBox(
                  width: double.maxFinite,
                  height: 300,
                  child: Consumer<DatabaseService>(
                    builder: (context, value, child) {
                      return value.result.isEmpty
                          ? const Text("Not found!")
                          : ListView.builder(
                              itemCount: value.result.length,
                              itemBuilder: (context, index) {
                                ModelUser searchedUser = ModelUser.fromMap(
                                    value.result[index].data());
                                // if member already exist-> show error
                                if (currentMemberUID
                                    .contains(searchedUser.uid)) {
                                  SchedulerBinding.instance
                                      .addPostFrameCallback((_) {
                                    MyAlertDialog(
                                      context,
                                      msg: "User was existed in the workspace",
                                      onOkay: () => Navigator.pop(context),
                                    );
                                  });
                                  return const Text(
                                      "User was existed in the workspace");
                                }
                                return GestureDetector(
                                  onTap: () {
                                    var userTile =
                                        _userTileGlobalKey.currentState!;
                                    // change color of user tile when tapped
                                    userTile.changeState();
                                    // add uid to members of chat
                                    currentMemberUID
                                        .add(value.result[index].id.toString());
                                  },
                                  child: MyUserTileOverview(
                                    key: _userTileGlobalKey,
                                    userName:
                                        value.result[index].data()["userName"],
                                    msg: "sample",
                                    onRemove: () {},
                                  ),
                                );
                              },
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
          // save or cancel action
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                var userTile = _userTileGlobalKey.currentState;

                /// if user was not selected -> show alert
                if (userTile == null || userTile.widget.isSelected == false) {
                  MyAlertDialog(
                    context,
                    msg: "User must be selected",
                    onOkay: () => Navigator.pop(context),
                  );
                } else {
                  WorkspaceService.instance.addUser(
                    newMemberList: currentMemberUID,
                    docID: workspaceID,
                    uid: currentMemberUID.last,
                  );
                  // get model user was recently added
                  final myModel =
                      Provider.of<DatabaseService>(context, listen: false);
                  var userModel = ModelUser.fromMap(
                      myModel.result[0].data() as Map<String, dynamic>);
                  // notify to user was recently added
                  NotificationService.instance.sendNotification(
                    receiverToken: userModel.fcm,
                    title: "You was added to ${modelWorkspace.workspaceName}",
                  );
                  // reload to get latest data
                  setState(() {});
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
