import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_snackbar.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_task.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_user.dart';
import 'package:phan_mem_giao_nhac_viec/services/task/task_service.dart';
import 'package:phan_mem_giao_nhac_viec/ultis/add_space.dart';

class DetailTaskPage extends StatefulWidget {
  final ModelTask modelTask;
  final String idTask;
  bool isWorkspace;
  String? workspaceName;
  final List<ModelUser>? memberList;
  DetailTaskPage({
    super.key,
    required this.modelTask,
    required this.idTask,
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
  final TaskService taskService = TaskService();
  Timestamp? startTime;
  Timestamp? due;
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

        await taskService.UpdateTaskFromDb(widget.idTask, widget.modelTask);
        if (context.mounted) {
          MySnackBar(context, "Task Modified");
        }
      } catch (e) {
        MyAlertDialog(context, e.toString());
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
      List<DateTime>? dateTimeList =
          await showOmniDateTimeRangePicker(context: context);

      if (dateTimeList != null) {
        startTime = Timestamp.fromMillisecondsSinceEpoch(
            dateTimeList[0].millisecondsSinceEpoch);
        due = Timestamp.fromMillisecondsSinceEpoch(
            dateTimeList[1].millisecondsSinceEpoch);
      }

      // if startTime > due => show error and reselect
      if (DateTime.fromMillisecondsSinceEpoch(startTime!.millisecondsSinceEpoch)
              .compareTo(DateTime.fromMillisecondsSinceEpoch(
                  due!.millisecondsSinceEpoch)) ==
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
      appBar: AppBar(
        title: const Text("Task details"),
        actions: [
          IconButton(
            onPressed: OnEdit,
            icon: isEdit ? const Icon(Icons.check) : const Icon(Icons.edit),
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
              // task title
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
              // created at
              Text(
                "Created at: ${DateTime.fromMillisecondsSinceEpoch(widget.modelTask.createAt.millisecondsSinceEpoch)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // these field is for workspace only
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
              Text(startTime == null
                  ? ""
                  : "Start: ${DateTime.fromMillisecondsSinceEpoch(startTime!.millisecondsSinceEpoch).toLocal()}"),
              // due
              Text(due == null
                  ? ""
                  : "Due: ${DateTime.fromMillisecondsSinceEpoch(due!.millisecondsSinceEpoch).toLocal()}"),
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
