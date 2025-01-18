import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:horizontal_week_calendar/horizontal_week_calendar.dart';

import 'package:phan_mem_giao_nhac_viec/components/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/view/widgets/my_task_tile_overview.dart';
import 'package:phan_mem_giao_nhac_viec/core/constraint/constraint.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/model/task_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/repositories/task_local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/view_model/task_view_model.dart';
import 'package:phan_mem_giao_nhac_viec/main.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/view/pages/add_task.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/view/pages/detail_task_page.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {
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

  removeTaskFromDb(String taskID) async {
    try {
      TaskViewModel.instance.removeTask(taskID: taskID);
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
                // close alert dialog
                Navigator.pop(context);
                // switch back to right before screen
                Navigator.pop(context);
                // sync task in hive
                TaskLocalRepo.instance.syncData();
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
      color: Theme.of(context).scaffoldBackgroundColor,
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
                      borderRadius: BorderRadius.circular(16),
                      showNavigationButtons: false,
                      inactiveBackgroundColor: Colors.transparent,
                      inactiveTextColor: Colors.black,
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
        valueListenable: TaskLocalRepo.instance.taskHiveBox.listenable(),
        builder: (context, value, child) {
          if (value.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.nothingToShowHere),
            );
          }
          var currentTaskPageState = taskPageGlobalKey.currentState!;

          var taskByDay = TaskViewModel.instance
              .getTaskByDay(currentDay: currentTaskPageState.currentDate);

          return ListView.builder(
            itemCount: taskByDay.length,
            itemBuilder: (context, index) {
              var modelTask = taskByDay.values.elementAt(index);
              var idTask = taskByDay.keys.elementAt(index);
              return MyTaskTileOverview(
                modelTask: modelTask,
                color: myTaskColor[modelTask.state],
                onRemove: () async {
                  await currentTaskPageState.removeTaskFromDb(idTask);
                  // reload task
                  setState(() {});
                },
                onTap: () async {
                  await currentTaskPageState.OpenTaskDetail(
                    modelTask,
                    idTask,
                  );
                  // sync task data
                  TaskViewModel.instance.syncData();
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
