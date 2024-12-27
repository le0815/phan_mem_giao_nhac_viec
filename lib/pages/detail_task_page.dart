import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_date_time_select.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_snackbar.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/constraint/constraint.dart';
import 'package:phan_mem_giao_nhac_viec/local_database/hive_boxes.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_task.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_user.dart';
import 'package:phan_mem_giao_nhac_viec/services/task/task_service.dart';
import 'package:phan_mem_giao_nhac_viec/ultis/add_space.dart';

class DetailTaskPage extends StatefulWidget {
  final ModelTask modelTask;
  final String idTask;
  final Function() onRemove;
  bool isWorkspace;
  String? workspaceName;
  final List<ModelUser>? memberList;
  DetailTaskPage({
    super.key,
    required this.modelTask,
    required this.idTask,
    required this.onRemove,
    this.isWorkspace = false,
    this.workspaceName,
    this.memberList,
  });

  @override
  State<DetailTaskPage> createState() => _DetailTaskPageState();
}

class _DetailTaskPageState extends State<DetailTaskPage> {
  final TextEditingController textTitleController = TextEditingController();
  final TextEditingController textDescriptionController =
      TextEditingController();
  // final TaskService taskService = TaskService();
  int? startTime;
  int? due;
  final workSpaceFiledGlobalKey = GlobalKey<WorkspaceFieldState>();

  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    textTitleController.text = widget.modelTask.title;
    textDescriptionController.text = widget.modelTask.description;

    super.initState();
  }

  OnEdit() async {
    // if isEdit == true => change state and upload modified data to db
    if (isEdit) {
      isEdit = false;
      try {
        // update new data to model
        widget.modelTask.title = textTitleController.text;
        widget.modelTask.description = textDescriptionController.text;
        if (startTime != null) {
          widget.modelTask.startTime = startTime;
          widget.modelTask.due = due;
        }

        // update task if is workspace mode
        if (widget.isWorkspace) {
          // if have change in assignee
          if (workSpaceFiledGlobalKey.currentState!.selectedAssignee != null) {
            widget.modelTask.uid =
                workSpaceFiledGlobalKey.currentState!.selectedAssignee!;
          }
        }

        // update timeUpdate
        widget.modelTask.timeUpdate = DateTime.now().millisecondsSinceEpoch;

        await TaskService.instance
            .UpdateTaskFromDb(widget.idTask, widget.modelTask);
        if (context.mounted) {
          MySnackBar(context, "Task Modified");
        }
      } catch (e) {
        MyAlertDialog(
          context,
          msg: e.toString(),
          onOkay: () => Navigator.pop(context),
        );
      }

      // MySnackbar(context);
    } else {
      isEdit = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    GetDates() async {
      try {
        var result = await myDateTimeSelect(context);
        startTime = result[0];
        due = result[1];
      } catch (e) {
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
      appBar: AppBar(
        title: const Text("Task details"),
        actions: [
          IconButton(
            onPressed: OnEdit,
            icon: isEdit ? const Icon(Icons.check) : const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              widget.onRemove();
            },
            icon: const Icon(Icons.delete_outline),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // task title
              const Text(
                "Title",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              MyTextfield(
                textController: textTitleController,
                readOnly: !isEdit,
              ),
              AddVerticalSpace(10),
              // task description
              const Text(
                "Description",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              MyTextfield(
                textController: textDescriptionController,
                maxLines: 6,
                readOnly: !isEdit,
              ),
              AddVerticalSpace(10),
              // task state
              Row(
                children: [
                  const Text(
                    "State",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  AddHorizontalSpace(10),
                  taskState(),
                ],
              ),
              AddVerticalSpace(10),
              // created at
              Text(
                "Created at: ${DateTime.fromMillisecondsSinceEpoch(widget.modelTask.createAt)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // these field is for workspace only
              // select member for workspace
              widget.isWorkspace
                  ? WorkspaceField(
                      key: workSpaceFiledGlobalKey,
                      workspaceName: widget.workspaceName!,
                      memberList: widget.memberList!,
                      assigner: widget.modelTask.assigner!,
                      selectedAssignee: widget.modelTask.uid,
                      isEdit: isEdit,
                    )
                  : AddVerticalSpace(10),
              // Due to
              DateTimePicker(GetDates),
            ],
          ),
        ),
      ),
    );
  }

  Widget taskState() {
    return isEdit
        ? // dropdown user in workspace
        DropdownButton(
            value: widget.modelTask.state,
            items: List.generate(
              MyTaskState.values.length,
              (int index) => DropdownMenuItem(
                value: MyTaskState.values[index].name,
                child: Text(
                  MyTaskState.values[index].name,
                ),
              ),
            ),
            onChanged: (value) {
              setState(
                () {
                  // update task model state
                  widget.modelTask.state = value.toString();
                },
              );
            },
          )
        : Text(
            widget.modelTask.state,
            style: const TextStyle(
              fontSize: 18,
            ),
          );
  }

  GestureDetector DateTimePicker(Future<dynamic> GetDates()) {
    return GestureDetector(
      onTap: () async {
        // only edit mode can modify the time of the task
        if (isEdit) {
          await GetDates();
        }
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
              // startTime
              // if time wasn't edited => show time of the task
              Text(startTime == null
                  ? widget.modelTask.startTime == null
                      ? ""
                      : "Start: ${DateTime.fromMillisecondsSinceEpoch(widget.modelTask.startTime!).toLocal()}"
                  : "Start: ${DateTime.fromMillisecondsSinceEpoch(startTime!).toLocal()}"),
              // due
              Text(due == null
                  ? widget.modelTask.due == null
                      ? ""
                      : "Due: ${DateTime.fromMillisecondsSinceEpoch(widget.modelTask.due!).toLocal()}"
                  : "Due: ${DateTime.fromMillisecondsSinceEpoch(due!).toLocal()}"),
            ],
          ),
        ],
      ),
    );
  }
}

class WorkspaceField extends StatefulWidget {
  final String workspaceName;
  String selectedAssignee;
  final String assigner;
  final List<ModelUser> memberList;
  bool isEdit;
  WorkspaceField({
    super.key,
    required this.workspaceName,
    required this.selectedAssignee,
    required this.memberList,
    required this.assigner,
    required this.isEdit,
  });

  @override
  State<WorkspaceField> createState() => WorkspaceFieldState();
}

class WorkspaceFieldState extends State<WorkspaceField> {
  String? selectedAssignee;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddVerticalSpace(10),
        // Workspace
        Text(
          "Workspace: ${widget.workspaceName}",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        AddVerticalSpace(10),
        // assigner
        Text(
          "Assigner: ${widget.memberList.where((element) => element.uid == widget.assigner).first.userName}",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        AddVerticalSpace(10),
        // assignee
        Row(
          children: [
            const Text(
              "Assignee: ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            // only reselect when edit mode turned on
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return widget.isEdit
                    ? // dropdown user in workspace
                    DropdownButton(
                        value: widget.selectedAssignee,
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
                          setState(
                            () {
                              widget.selectedAssignee = value.toString();
                              selectedAssignee = value.toString();
                            },
                          );
                        },
                      )
                    : Text(
                        widget.memberList
                            .where((element) =>
                                element.uid == widget.selectedAssignee)
                            .first
                            .userName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      );
              },
            ),
            // datetime picker for due
          ],
        ),
      ],
    );
  }
}
