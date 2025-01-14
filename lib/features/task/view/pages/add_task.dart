import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:phan_mem_giao_nhac_viec/components/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/view/widgets/my_date_time_select.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_elevated_button_long.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_snackbar.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/core/constraint/constraint.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/model/task_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/repositories/task_remote_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/view_model/task_view_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/model/user_model.dart';
import 'package:phan_mem_giao_nhac_viec/core/services/background_service.dart';
import 'package:phan_mem_giao_nhac_viec/services/database/database_service.dart';
import 'package:phan_mem_giao_nhac_viec/core/services/notification_service.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/add_space.dart';

class AddTask extends StatefulWidget {
  final List<UserModel>? memberList;
  final String? workspaceID;
  bool isWorkspace;
  AddTask({
    super.key,
    this.memberList,
    this.workspaceID,
    this.isWorkspace = false,
  });
  int? startTime;
  int? due;
  var taskTitleController = TextEditingController();
  var taskDescriptionController = TextEditingController();
  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  String? selectedUser;

  @override
  Widget build(BuildContext context) {
    // final TaskService taskService = TaskService();

    Future<void> UploadTask({required String? uid}) async {
      try {
        await TaskRemoteRepo.instance.AddTaskToDb(
          // if task was created in workspace mode, the uid of task is uid of
          // assignee and assigner now set to current uid
          TaskModel(
            title: widget.taskTitleController.text.trim(),
            description: widget.taskDescriptionController.text.trim(),
            uid: widget.isWorkspace
                ? uid!
                : FirebaseAuth.instance.currentUser!.uid,
            createAt: DateTime.now().millisecondsSinceEpoch,
            due: widget.due,
            startTime: widget.startTime,
            assigner: widget.isWorkspace
                ? FirebaseAuth.instance.currentUser!.uid
                : null,
            workspaceID: widget.isWorkspace ? widget.workspaceID : null,
            // if task was no due the state = inProgress
            // if task has due, the state = pending (startTime > createAt)
            //                            = inProgress (startTime < createAt)
            state: widget.startTime == null
                ? MyTaskState.inProgress.name
                : MyTaskState.pending.name,
            timeUpdate: DateTime.now().millisecondsSinceEpoch,
          ),
        );
        log("upload task is ok");

        // if is workspace mode -> send notifi to trigger update task on member device
        // else update task
        if (widget.isWorkspace) {
          UserModel modelMember =
              await DatabaseService.instance.getUserByUID(uid!);
          NotificationService.instance.sendNotification(
              receiverToken: modelMember.fcm,
              title:
                  AppLocalizations.of(context)!.youHaveANewTaskInYourWorkSpace,
              payload: {
                "notificationType": "remote",
                "0": SyncTypes.syncTask,
              });
          await TaskViewModel.instance.syncData();
        } else {
          await TaskViewModel.instance.syncData();
        }
        // create alarm for the task
        BackgroundService.instance.setScheduleAlarm();

        // close loading indicator
        if (context.mounted) {
          // close add task page
          Navigator.pop(context);
        }
      } catch (e) {
        MyAlertDialog(
          context,
          msg: e.toString(),
          onOkay: () => Navigator.pop(context),
        );
        log(e.toString());
      }
    }

    GetDates() async {
      try {
        var result = await myDateTimeSelect(context);
        widget.startTime = result[0];
        widget.due = result[1];
      } catch (e) {
        log("message: $e");
        log("myDateTimeException: ${myDateTimeException[0]}");
        // if datetime was not set => switch back to screen
        if (e.toString() == myDateTimeException[0].toString()) {
          return;
        } else {
          await GetDates();
        }
      }
      setState(() {});
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addNewTask),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // InputField for title and description
                InputField(widget.taskTitleController,
                    widget.taskDescriptionController),

                widget.isWorkspace
                    ? // assign task to the member
                    Row(
                        children: [
                          Text(AppLocalizations.of(context)!.assignTo),
                          DropdownButton(
                            value: selectedUser,
                            items: List.generate(
                              widget.memberList!.length,
                              (int index) => DropdownMenuItem(
                                value: widget.memberList![index].uid,
                                child: Text(
                                  widget.memberList![index].userName,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedUser = value.toString();
                              });
                            },
                          ),
                        ],
                      )
                    : AddVerticalSpace(1),

                // datetime picker for due
                DateTimePicker(GetDates),

                // submit
                Row(
                  children: [
                    Expanded(
                      child: MyElevatedButtonLong(
                        onPress: () {
                          // if user was not selected -> show error
                          if (widget.isWorkspace) {
                            if (selectedUser == null) {
                              MySnackBar(
                                  context,
                                  AppLocalizations.of(context)!
                                      .userMustBeSelected);
                              return;
                            }
                            UploadTask(uid: selectedUser!);
                          } else {
                            // not workspace mode
                            UploadTask(uid: null);
                          }
                        },
                        title: "Submit",
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector DateTimePicker(Future<dynamic> GetDates()) {
    return GestureDetector(
      onTap: () async {
        await GetDates();
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Icon(
            Icons.calendar_month_outlined,
            size: 32,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddHorizontalSpace(10),
              // createAt
              Text(widget.startTime == null
                  ? ""
                  : "${AppLocalizations.of(context)!.start}: ${DateTime.fromMillisecondsSinceEpoch(widget.startTime!).toLocal()}"),
              // due
              Text(widget.due == null
                  ? ""
                  : "${AppLocalizations.of(context)!.due}: ${DateTime.fromMillisecondsSinceEpoch(widget.due!).toLocal()}"),
            ],
          ),
        ],
      ),
    );
  }

  Column InputField(TextEditingController taskTitleController,
      TextEditingController taskDescriptionController) {
    return Column(
      children: [
        // title
        MyTextfield(
            textFieldHint: AppLocalizations.of(context)!.title,
            textController: taskTitleController),
        AddVerticalSpace(12),
        // description
        MyTextfield(
          textFieldHint: AppLocalizations.of(context)!.description,
          textController: taskDescriptionController,
          maxLines: 6,
        ),
      ],
    );
  }
}
