import 'package:flutter/material.dart';

import 'package:phan_mem_giao_nhac_viec/components/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/core/constraint/constraint.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/model/task_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/repositories/task_remote_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/view/pages/detail_task_page.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/view/widgets/my_task_tile_overview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailSectionPieChart extends StatefulWidget {
  final Map<String, dynamic> modelTasks;
  const DetailSectionPieChart({super.key, required this.modelTasks});

  @override
  State<DetailSectionPieChart> createState() => _DetailSectionPieChartState();
}

class _DetailSectionPieChartState extends State<DetailSectionPieChart> {
  // final taskService = TaskService();
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
      await TaskRemoteRepo.instance.RemoveTaskFromDb(taskId);
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

  OpenTaskDetail(TaskModel modelTask, String idTask) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailTaskPage(
          onRemove: () {
            // show alert
            MyAlertDialog(
              context,
              msg: AppLocalizations.of(context)!.areYouSureWantToDeleteThisTask,
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
        title: Text(AppLocalizations.of(context)!.detailSection),
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
