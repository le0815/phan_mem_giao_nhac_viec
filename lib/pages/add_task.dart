import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_elevated_button_long.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_loading_indicator.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_snackbar.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_task.dart';
import 'package:phan_mem_giao_nhac_viec/services/task/task_service.dart';
import 'package:phan_mem_giao_nhac_viec/ultis/add_space.dart';

class AddTask extends StatefulWidget {
  AddTask({super.key});
  Timestamp? createAt;
  Timestamp? due;
  var taskTitleController = TextEditingController();
  var taskDescriptionController = TextEditingController();
  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  @override
  Widget build(BuildContext context) {
    final TaskService taskService = TaskService();

    Future<void> UploadTask() async {
      try {
        await taskService.AddTaskToDb(
          ModelTask(
              titleTask: widget.taskTitleController.text.trim(),
              descriptionTask: widget.taskDescriptionController.text.trim(),
              uid: FirebaseAuth.instance.currentUser!.uid,
              createAt: widget.createAt!,
              due: widget.due),
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
      if (dateTimeList == null) {
        return;
      }
      widget.createAt = Timestamp.fromMillisecondsSinceEpoch(
          dateTimeList[0].millisecondsSinceEpoch);
      widget.due = Timestamp.fromMillisecondsSinceEpoch(
          dateTimeList[1].millisecondsSinceEpoch);

      // if createAt > due =>
      if (DateTime.fromMillisecondsSinceEpoch(
                  widget.createAt!.millisecondsSinceEpoch)
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

                // datetime picker for due
                DateTimePicker(GetDates),

                // submit
                Row(
                  children: [
                    Expanded(
                      child: MyElevatedButtonLong(
                        onPress: () {
                          UploadTask();
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
              Text(widget.createAt == null
                  ? ""
                  : "Create At: ${DateTime.fromMillisecondsSinceEpoch(widget.createAt!.millisecondsSinceEpoch).toLocal()}"),
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
