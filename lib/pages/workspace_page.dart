import 'dart:developer';

import 'package:calendar_view/calendar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_loading_indicator.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_user_tile_overview.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_task.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_user.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_workspace.dart';
import 'package:phan_mem_giao_nhac_viec/pages/add_task.dart';
import 'package:phan_mem_giao_nhac_viec/pages/detail_task_page.dart';
import 'package:phan_mem_giao_nhac_viec/services/database/database_service.dart';
import 'package:phan_mem_giao_nhac_viec/services/workspace/workspace_service.dart';
import 'package:phan_mem_giao_nhac_viec/ultis/add_space.dart';
import 'package:provider/provider.dart';

class WorkspacePage extends StatefulWidget {
  final ModelWorkspace modelWorkspace;
  final String workspaceID;

  const WorkspacePage({
    super.key,
    required this.modelWorkspace,
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

  final databaseService = DatabaseService();
  List<CalendarEventData> events = [];
  List<ModelUser> membersOfWorkspace = [];
  var calendarController;
  Future<List> getUsers() async {
    final List<ModelUser> userList = [];
    for (var element in widget.modelWorkspace.members) {
      var result = await databaseService.getUserByUID(element);
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

  getAllTasks() async {
    clearTaskResult();

    Map taskResult =
        await databaseService.GetTasksFromWorkspace(widget.workspaceID);
    // get event form database
    taskResult.forEach(
      (key, value) {
        CalendarEventData event;
        // if task have due
        if (value.data()["startTime"] != null) {
          event = CalendarEventData(
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

  @override
  void didChangeDependencies() {
    calendarController = CalendarControllerProvider.of(context).controller;
    getAllTasks();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.modelWorkspace.workspaceName),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.add), // Icon for the button
            onSelected: (value) {
              // Handle selected value
              if (value == 0) {
                addMemberDialog(
                    context, widget.modelWorkspace.members, widget.workspaceID);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Text('Add member'),
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
                        modelTask: ModelTask.fromMap(
                            (event.event as Map)["modelTask"]),
                        idTask: (event.event as Map)["id"],
                        isWorkspace: true,
                        workspaceName: widget.modelWorkspace.workspaceName,
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
                            return MyUserTileOverview(
                              userName: result[index].userName,
                              msg: result[index].email,
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

  addMemberDialog(
      BuildContext context, List currentMemberUID, String workspaceID) {
    TextEditingController searchPhaseController = TextEditingController();
    TextEditingController chatNameController = TextEditingController();
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
                                return GestureDetector(
                                  onTap: () {
                                    // change color of user tile when tapped
                                    final userTile =
                                        _userTileGlobalKey.currentState!;
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
                WorkspaceService.addUser(
                  newMemberList: currentMemberUID,
                  docID: workspaceID,
                  uid: currentMemberUID.last,
                );
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
