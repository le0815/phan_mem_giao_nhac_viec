import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_snackbar.dart';
import 'package:phan_mem_giao_nhac_viec/core/constraint/constraint.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/add_space.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/model/task_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/view/widgets/datetime_section.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/view/widgets/my_input_section.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/view/widgets/my_taskstate_section.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/view_model/task_view_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/model/user_model.dart';

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

  final workSpaceFiledGlobalKey = GlobalKey<WorkspaceFieldState>();

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
      );
      setState(() {});
      if (context.mounted) {
        MySnackBar(context, AppLocalizations.of(context)!.taskModified);
      }
    } catch (e) {
      MyAlertDialog(
        context,
        msg: e.toString(),
        onOkay: () => Navigator.pop(context),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Datetime
                  DatetimeSection(
                    detailTaskPageWidget: widget,
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
                  widget.isWorkspace
                      ? WorkspaceField(
                          key: workSpaceFiledGlobalKey,
                          workspaceName: widget.workspaceName!,
                          memberList: widget.memberList!,
                          assigner: widget.modelTask.assigner!,
                          selectedAssignee: widget.modelTask.uid,
                        )
                      : AddVerticalSpace(10),
                ],
              ),
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
                    child: const Text("Save Change"),
                  ),
                ),
              ],
            ),
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
  final List<UserModel> memberList;

  WorkspaceField({
    super.key,
    required this.workspaceName,
    required this.selectedAssignee,
    required this.memberList,
    required this.assigner,
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
          "${AppLocalizations.of(context)!.workspace}: ${widget.workspaceName}",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        AddVerticalSpace(10),
        // assigner
        Text(
          "${AppLocalizations.of(context)!.assigner}: ${widget.memberList.where((element) => element.uid == widget.assigner).first.userName}",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        AddVerticalSpace(10),
        // assignee
        Row(
          children: [
            Text(
              "${AppLocalizations.of(context)!.assignee}: ",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            // only reselect when edit mode turned on
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                // dropdown user in workspace
                return DropdownButton(
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
