import 'dart:developer';

import 'package:calendar_view/calendar_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:phan_mem_giao_nhac_viec/core/widgets/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/add_space.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/view/pages/add_task.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/view/pages/detail_task_page.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/model/user_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/workspace/models/model_workspace.dart';
import 'package:phan_mem_giao_nhac_viec/features/workspace/view/widgets/member_workspace_list.dart';
import 'package:phan_mem_giao_nhac_viec/features/workspace/view/widgets/my_legend_chart.dart';
import 'package:phan_mem_giao_nhac_viec/features/workspace/view/widgets/popupMenuButton_detail_workspace.dart';
import 'package:phan_mem_giao_nhac_viec/features/workspace/view_model/workspace_viewmodel.dart';

class DetailWorkspacePage extends StatefulWidget {
  final ModelWorkspace modelWorkspace;
  final Map modelDetailMembers;
  final String workspaceID;

  const DetailWorkspacePage({
    super.key,
    required this.modelWorkspace,
    required this.workspaceID,
    required this.modelDetailMembers,
  });

  @override
  State<DetailWorkspacePage> createState() => DetailWorkspacePageState();
}

class DetailWorkspacePageState extends State<DetailWorkspacePage> {
  // final taskService = TaskService();
  var currentUID = FirebaseAuth.instance.currentUser!.uid;
  String? currentUserRole;
  List<CalendarEventData> events = [];
  List<UserModel> modelUserMember = [];
  EventController? calendarController;

  @override
  void didChangeDependencies() {
    calendarController = CalendarControllerProvider.of(context).controller;
    // add all related task to the event
    WorkspaceViewModel.instance.addEvents(workspaceID: widget.workspaceID);
    // get user role
    currentUserRole = WorkspaceViewModel.instance.getCurrentUserRole(
      modelDetailMembers: widget.modelDetailMembers,
      uid: currentUID,
    );
    // get user model
    WorkspaceViewModel.instance.getModelUserMembers();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.modelWorkspace.workspaceName,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          PopupMenuButtonDetailWorkspace(
            workspaceID: widget.workspaceID,
            currentUserRole: currentUserRole!,
            modelWorkspace: widget.modelWorkspace,
            uid: currentUID,
            modelDetailMembers: widget.modelDetailMembers,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // show workspace task overview
            SizedBox(
              height: 500,
              child: monthCalendar(context),
            ),
            // show annotation for the calendar
            AddVerticalSpace(8),
            const MyLegendChart(),
            // show members of workspace
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MemberWorkspaceList(
                workspaceID: widget.workspaceID,
                modelWorkspace: widget.modelWorkspace,
                membersDetail: widget.modelDetailMembers,
              ),
            )
          ],
        ),
      ),
    );
  }

  MonthView<Object?> monthCalendar(BuildContext context) {
    return MonthView(
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
                  context: context,
                  msg: AppLocalizations.of(context)!
                      .areYouSureWantToDeleteThisTask,
                  onPressed: () async {
                    await WorkspaceViewModel.instance
                        .removeTask(taskID: (event.event as Map)["id"]);
                    // close alert dialog
                    Navigator.pop(context);
                    // switch back to right before screen
                    Navigator.pop(context);

                    // reload task overview
                    WorkspaceViewModel.instance
                        .addEvents(workspaceID: widget.workspaceID);
                  },
                );
              },
              modelTask: (event.event as Map)["modelTask"],
              idTask: (event.event as Map)["id"],
              isWorkspace: true,
              workspaceName: widget.modelWorkspace.workspaceName,
              memberList: modelUserMember,
            ),
          ),
        );
      },
      onDateLongPress: (date) async {
        // navigation to add task page
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddTask(
              memberList: modelUserMember,
              workspaceID: widget.workspaceID,
              isWorkspace: true,
            ),
          ),
        );
        // reload task overview
        WorkspaceViewModel.instance.addEvents(workspaceID: widget.workspaceID);
      },
    );
  }
}
