import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:phan_mem_giao_nhac_viec/components/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/constraint/constraint.dart';
import 'package:phan_mem_giao_nhac_viec/pages/detail_task_page.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_task_tile_overview.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_task.dart';
import 'package:phan_mem_giao_nhac_viec/services/task/task_service.dart';

class DetailSectionPieChart extends StatefulWidget {
  final Map<String, dynamic> modelTasks;
  const DetailSectionPieChart({super.key, required this.modelTasks});

  @override
  State<DetailSectionPieChart> createState() => _DetailSectionPieChartState();
}

class _DetailSectionPieChartState extends State<DetailSectionPieChart> {
  final taskService = TaskService();
  // use list object to changeable value after pass to function
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // get task from database
  //   SchedulerBinding.instance.addPostFrameCallback((_) {
  //     GetTaskByDay(context, currentDate[0]);
  //   });
  // }

  RemoveTaskFromDb(String taskId) async {
    try {
      await taskService.RemoveTaskFromDb(taskId);
    } catch (e) {
      if (context.mounted) {
        // show err dialog
        MyAlertDialog(
          context,
          msg: e.toString(),
          onOkay: () => Navigator.pop(context),
        );
      }
    }
  }

  OpenTaskDetail(ModelTask modelTask, String idTask) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailTaskPage(
          onRemove: () {
            // show alert
            MyAlertDialog(
              context,
              msg: "Are you sure want to delete this task?",
              onOkay: () {
                RemoveTaskFromDb(idTask);
                // close alert dialog
                Navigator.pop(context);
                // switch back to right before screen
                Navigator.pop(context);
              },
            );
          },
          modelTask: modelTask,
          idTask: idTask,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail section"),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: // task overview per day
                  ListView.builder(
                itemCount: widget.modelTasks.length,
                itemBuilder: (context, index) {
                  var modelTask = widget.modelTasks.values.elementAt(index);
                  var taskDocID = widget.modelTasks.keys.elementAt(index);
                  return MyTaskTileOverview(
                    modelTask: modelTask,
                    color: myTaskColor[modelTask.state],
                    onRemove: () async {
                      await RemoveTaskFromDb(taskDocID);
                      // reload task
                      setState(() {});
                    },
                    onTap: () async {
                      await OpenTaskDetail(
                        modelTask,
                        taskDocID,
                      );
                      // reload task overview
                      setState(() {});
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
