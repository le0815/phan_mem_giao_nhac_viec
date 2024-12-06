import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_elevated_button_long.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_snackbar.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_task.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_user.dart';
import 'package:phan_mem_giao_nhac_viec/services/task/task_service.dart';
import 'package:phan_mem_giao_nhac_viec/ultis/add_space.dart';

class AddTaskWorkspace extends StatefulWidget {
  final List<ModelUser> memberList;
  final String workspaceID;
  AddTaskWorkspace({
    super.key,
    required this.memberList,
    required this.workspaceID,
  });
  Timestamp? startTime;
  Timestamp? due;
  var taskTitleController = TextEditingController();
  var taskDescriptionController = TextEditingController();
  @override
  State<AddTaskWorkspace> createState() => _AddTaskWorkspaceState();
}

class _AddTaskWorkspaceState extends State<AddTaskWorkspace> {
  String? selectedUser;

  @override
  Widget build(BuildContext context) {
    final TaskService taskService = TaskService();

    Future<void> UploadTask({required String uid}) async {
      try {
        await taskService.AddTaskToDb(
          ModelTask(
            title: widget.taskTitleController.text.trim(),
            description: widget.taskDescriptionController.text.trim(),
            uid: uid,
            createAt: Timestamp.now(),
            due: widget.due,
            startTime: widget.startTime,
            assigner: FirebaseAuth.instance.currentUser!.uid,
            workspaceID: widget.workspaceID,
          ),
        );
        log("upload task is ok");

        // close loading indicator
        if (context.mounted) {
          // close add task page
          Navigator.pop(context);
        }
      } catch (e) {
        MyAlertDialog(context, e.toString());
        log(e.toString());
      }
    }

    GetDates() async {
      List<DateTime>? dateTimeList =
          await showOmniDateTimeRangePicker(context: context);

      if (dateTimeList != null) {
        widget.startTime = Timestamp.fromMillisecondsSinceEpoch(
            dateTimeList[0].millisecondsSinceEpoch);
        widget.due = Timestamp.fromMillisecondsSinceEpoch(
            dateTimeList[1].millisecondsSinceEpoch);
      }

      // if startTime > due => show error and reselect
      if (DateTime.fromMillisecondsSinceEpoch(
                  widget.startTime!.millisecondsSinceEpoch)
              .compareTo(DateTime.fromMillisecondsSinceEpoch(
                  widget.due!.millisecondsSinceEpoch)) ==
          1) {
        log("Start time must be equal or greater than end time");
        if (context.mounted) {
          MySnackBar(
              context, "Start time must be equal or greater than end time");
        }
        return GetDates();
      }
      setState(() {});
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add New Task"),
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

                // assign task to the member
                Row(
                  children: [
                    Text("Assign to: "),
                    DropdownButton(
                      value: selectedUser,
                      items: List.generate(
                        widget.memberList.length,
                        (int index) => DropdownMenuItem(
                          value: widget.memberList[index].uid,
                          child: Text(
                            widget.memberList[index].userName,
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
                ),

                // datetime picker for due
                DateTimePicker(GetDates),

                // submit
                Row(
                  children: [
                    Expanded(
                      child: MyElevatedButtonLong(
                        onPress: () {
                          // if user was not selected -> show error
                          if (selectedUser == null) {
                            MySnackBar(context, "User must be selected");
                            return;
                          }
                          UploadTask(uid: selectedUser!);
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
                  : "Create At: ${DateTime.fromMillisecondsSinceEpoch(widget.startTime!.millisecondsSinceEpoch).toLocal()}"),
              // due
              Text(widget.due == null
                  ? ""
                  : "Due: ${DateTime.fromMillisecondsSinceEpoch(widget.due!.millisecondsSinceEpoch).toLocal()}"),
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
            textFieldHint: "Title", textController: taskTitleController),
        AddVerticalSpace(12),
        // description
        MyTextfield(
          textFieldHint: "Description",
          textController: taskDescriptionController,
          maxLines: 6,
        ),
      ],
    );
  }
}
