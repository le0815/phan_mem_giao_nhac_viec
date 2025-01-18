import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:phan_mem_giao_nhac_viec/components/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/add_space.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/view/widgets/workspace_section.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/view/widgets/datetime_section.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/view/widgets/my_input_section.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/view_model/task_view_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/model/user_model.dart';
import 'package:phan_mem_giao_nhac_viec/main.dart';

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
  String? assigneeUID;
  String currentUID = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    // final TaskService taskService = TaskService();

    Future<void> UploadTask() async {
      try {
        await TaskViewModel.instance.createTask(
          uid: currentUID,
          title: widget.taskTitleController.text,
          description: widget.taskDescriptionController.text,
          startTime: widget.startTime,
          due: widget.due,
          isWorkspace: widget.isWorkspace,
          assigneeUID: assigneeUID,
          workspaceID: widget.workspaceID,
        );
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

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addNewTask),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // input section
              DatetimeSection(
                pageWidget: widget,
                isAddTaskPage: true,
              ),
              AddVerticalSpace(10),
              // task title
              MyInputSection(
                sectionName: "Title",
                textEditingController: widget.taskTitleController,
                maxLine: 1,
                textStyle: Theme.of(context).textTheme.titleMedium,
              ),
              AddVerticalSpace(10),
              // task description
              MyInputSection(
                sectionName: "Description",
                textEditingController: widget.taskDescriptionController,
                maxLine: 5,
              ),
              AddVerticalSpace(10),

              widget.isWorkspace
                  ? // assign task to the member
                  WorkspaceSection(
                      onSelectedUserUID: (value) {
                        assigneeUID = value;
                      },
                      key: workspaceSectionGlobalKey,
                      memberList: widget.memberList!,
                    )
                  : AddVerticalSpace(1),

              // submit
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  await UploadTask();
                },
                child: const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
