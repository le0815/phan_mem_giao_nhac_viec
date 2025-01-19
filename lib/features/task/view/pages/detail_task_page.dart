import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/my_snackbar.dart';
import 'package:phan_mem_giao_nhac_viec/core/constraint/constraint.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/add_space.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/model/task_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/view/widgets/datetime_section.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/view/widgets/my_input_section.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/view/widgets/my_taskstate_section.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/view/widgets/workspace_section.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/view_model/task_view_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/model/user_model.dart';
import 'package:phan_mem_giao_nhac_viec/main.dart';

class DetailTaskPage extends StatefulWidget {
  final TaskModel modelTask;
  final String idTask;
  final Function() onRemove;
  bool isWorkspace;
  String? workspaceName;
  int? startTime;
  int? due;
  late final String oldTaskState;
  final TextEditingController textTitleController = TextEditingController();
  final TextEditingController textDescriptionController =
      TextEditingController();
  final List<UserModel>? memberList;

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
  // final TaskService taskService = TaskService();

  String? assigneeUID;
  @override
  void initState() {
    // TODO: implement initState
    widget.textTitleController.text = widget.modelTask.title;
    widget.textDescriptionController.text = widget.modelTask.description;
    widget.oldTaskState = widget.modelTask.state;
    super.initState();
  }

  OnEdit() async {
    try {
      TaskViewModel.instance.editTask(
        taskID: widget.idTask,
        taskModel: widget.modelTask,
        isWorkspace: widget.isWorkspace,
        context: context,
        newStartTime: widget.startTime,
        newDue: widget.due,
        newTitle: widget.textTitleController.text,
        newDescription: widget.textDescriptionController.text,
        assigneeID: assigneeUID,
      );
      setState(() {});
      if (context.mounted) {
        MySnackBar(context, AppLocalizations.of(context)!.taskModified);
      }
    } catch (e) {
      MyAlertDialog(
        msg: e.toString(),
      );
    }
  }

  onSateChange() {
    if (widget.modelTask.state != MyTaskState.completed.name) {
      widget.modelTask.state = MyTaskState.completed.name;
    } else {
      widget.modelTask.state = widget.oldTaskState;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.taskDetails),
        actions: [
          IconButton(
            onPressed: () async {
              await widget.onRemove();
            },
            icon: const Icon(Icons.delete_outline),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Datetime
                  DatetimeSection(
                    pageWidget: widget,
                  ),
                  AddVerticalSpace(10),
                  // task title
                  MyInputSection(
                    sectionName: "Title",
                    textEditingController: widget.textTitleController,
                    maxLine: 1,
                    textStyle: Theme.of(context).textTheme.titleMedium,
                  ),
                  AddVerticalSpace(10),
                  // task description
                  MyInputSection(
                    sectionName: "Description",
                    textEditingController: widget.textDescriptionController,
                    maxLine: 5,
                  ),
                  AddVerticalSpace(10),
                  // task state
                  MyTaskstateSection(
                      onTap: onSateChange,
                      isComplete:
                          widget.modelTask.state == MyTaskState.completed.name
                              ? true
                              : false),
                  AddVerticalSpace(10),
                  // these field is for workspace only
                  // select member for workspace
                  // widget.isWorkspace
                  //     ? WorkspaceField(
                  //         key: workSpaceFiledGlobalKey,
                  //         workspaceName: widget.workspaceName!,
                  //         memberList: widget.memberList!,
                  //         assigner: widget.modelTask.assigner!,
                  //         selectedAssignee: widget.modelTask.uid,
                  //       )
                  //     : AddVerticalSpace(10),
                  widget.isWorkspace
                      ? WorkspaceSection(
                          key: workspaceSectionGlobalKey,
                          onSelectedUserUID: (value) {
                            // update new assignee UID
                            assigneeUID = value;
                          },
                          memberList: widget.memberList!,
                          isAddTaskMode: false,
                          assignerUID: widget.modelTask.assigner,
                          workspaceName: widget.workspaceName,
                          assigneeUID: widget.modelTask.uid,
                        )
                      : AddVerticalSpace(10),
                ],
              ),
            ),
            // save change button
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await OnEdit();
                      },
                      child: const Text("\nSave Change\n"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
