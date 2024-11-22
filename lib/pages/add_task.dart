import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_elevated_button_long.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_loading_indicator.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_task.dart';
import 'package:phan_mem_giao_nhac_viec/services/task/task_service.dart';
import 'package:phan_mem_giao_nhac_viec/ultis/add_space.dart';

class AddTask extends StatelessWidget {
  const AddTask({super.key});

  @override
  Widget build(BuildContext context) {
    var taskTitleController = TextEditingController();
    var taskDescriptionController = TextEditingController();

    final TaskService taskService = TaskService();

    Future<void> UploadTask() async {
      // show loading indicator
      MyLoadingIndicator(context);
      try {
        await taskService.AddTaskToDb(
          ModelTask(
            titleTask: taskTitleController.text.trim(),
            descriptionTask: taskDescriptionController.text.trim(),
            uid: FirebaseAuth.instance.currentUser!.uid,
          ),
        );
        log("upload task is ok");

        // close loading indicator
        if (context.mounted) {
          // close loading indicator
          Navigator.pop(context);
          // close add task page
          Navigator.pop(context);
        }
      } catch (e) {
        // close loading indicator
        if (context.mounted) {
          Navigator.pop(context);
        }
        MyAlertDialog(context, e.toString());
        log(e.toString());
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add New Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              // title
              MyTextfield(
                  textFieldHint: "Title", textController: taskTitleController),
              AddVerticalSpace(12),
              // description
              MyTextfield(
                  textFieldHint: "Description",
                  textController: taskDescriptionController),

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
    );
  }
}
