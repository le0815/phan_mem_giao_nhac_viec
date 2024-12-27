import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:horizontal_week_calendar/horizontal_week_calendar.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_loading_indicator.dart';
import 'package:phan_mem_giao_nhac_viec/constraint/constraint.dart';
import 'package:phan_mem_giao_nhac_viec/local_database/hive_boxes.dart';
import 'package:phan_mem_giao_nhac_viec/pages/add_task.dart';
import 'package:phan_mem_giao_nhac_viec/pages/detail_task_page.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_task_tile_overview.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_task.dart';
import 'package:phan_mem_giao_nhac_viec/services/database/database_service.dart';
import 'package:phan_mem_giao_nhac_viec/services/task/task_service.dart';
import 'package:workmanager/workmanager.dart';

import '../main.dart';

class BodyTask extends StatefulWidget {
  const BodyTask({super.key});

  @override
  State<BodyTask> createState() => BodyTaskState();
}

class BodyTaskState extends State<BodyTask> {
  // final taskService = TaskService();
  // use list object to changeable value after pass to function
  DateTime currentDate = DateTime.now();
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
      await TaskService.instance.RemoveTaskFromDb(taskId);
      // sync new data in hive
      HiveBoxes.instance.syncData(syncType: SyncTypes.syncTask);
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
                // sync task in hive
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
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    // week calendar
                    HorizontalWeekCalendar(
                      onDateChange: (date) {
                        setState(() {
                          currentDate = date;
                        });
                        log("current date: $currentDate");
                        // taskService.GetTaskByDay(currentDate);
                      },
                      initialDate: DateTime.now(),
                      minDate: DateTime(2024),
                      maxDate: DateTime(2028),
                      borderRadius: BorderRadius.circular(8),
                      showNavigationButtons: false,
                    ),
                    // task overview per day
                    TaskTileOverView(),
                  ],
                ),
                // add new task
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: FloatingActionButton(
                    onPressed: () async {
                      // await Navigator.pushNamed(context, "/add_task");
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddTask()),
                      );
                      // // reload page to load new task
                      setState(() {});
                    },
                    child: const Icon(
                      Icons.add,
                    ),
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

class TaskTileOverView extends StatefulWidget {
  const TaskTileOverView({super.key});

  @override
  State<TaskTileOverView> createState() => _TaskTileOverViewState();
}

class _TaskTileOverViewState extends State<TaskTileOverView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: HiveBoxes.instance.taskHiveBox.listenable(),
        builder: (context, value, child) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //     return const MyLoadingIndicator();
          //   }
          if (value.isEmpty) {
            return const Center(
              child: Text("Nothing to show here!"),
            );
          }
          var currentBodyTaskState = bodyTaskGlobalKey.currentState!;

          var taskData = value.toMap();
          var taskByDay = TaskService.instance.getTaskByDay(
              time: currentBodyTaskState.currentDate, taskData: taskData);
          return ListView.builder(
            itemCount: taskByDay.length,
            itemBuilder: (context, index) {
              var modelTask = taskByDay.values.elementAt(index);
              var idTask = taskByDay.keys.elementAt(index);
              return MyTaskTileOverview(
                modelTask: modelTask,
                color: myTaskColor[modelTask.state],
                onRemove: () async {
                  await currentBodyTaskState.RemoveTaskFromDb(idTask);
                  // reload task
                  // setState(() {});
                },
                onTap: () async {
                  await currentBodyTaskState.OpenTaskDetail(
                    modelTask,
                    idTask,
                  );
                  // sync task data
                  HiveBoxes.instance.syncData(syncType: SyncTypes.syncTask);

                  // setState(() {});
                },
              );
            },
          );
        },
      ),
    );
  }
}
