import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_snackbar.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_task.dart';
import 'package:phan_mem_giao_nhac_viec/services/task/task_service.dart';
import 'package:phan_mem_giao_nhac_viec/ultis/add_space.dart';

class MyTaskTileDetail extends StatefulWidget {
  final ModelTask modelTask;
  final String idTask;
  const MyTaskTileDetail(
      {super.key, required this.modelTask, required this.idTask});

  @override
  State<MyTaskTileDetail> createState() => _MyTaskTileDetailState();
}

class _MyTaskTileDetailState extends State<MyTaskTileDetail> {
  final TextEditingController textTitleController = TextEditingController();
  final TextEditingController textDescriptionController =
      TextEditingController();
  final TaskService taskService = TaskService();

  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    textTitleController.text = widget.modelTask.titleTask;
    textDescriptionController.text = widget.modelTask.descriptionTask;
    super.initState();
  }

  OnEdit() async {
    // if isEdit == true => change state and upload modified data to db
    if (isEdit) {
      isEdit = false;
      try {
        // update new data to model
        widget.modelTask.titleTask = textTitleController.text;
        widget.modelTask.descriptionTask = textDescriptionController.text;

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
              const Text(
                "Created at: Show time here",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AddVerticalSpace(10),
              // Workspace
              const Text(
                "Workspace: Show workspace here",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AddVerticalSpace(10),
              // assigner
              const Text(
                "Assigner: Show assigner here",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AddVerticalSpace(10),
              // Due to
              const Text(
                "Due to: Show time here",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
