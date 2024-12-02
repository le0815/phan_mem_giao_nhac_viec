import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:horizontal_week_calendar/horizontal_week_calendar.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_loading_indicator.dart';
import 'package:phan_mem_giao_nhac_viec/pages/detail_task_page.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_task_tile_overview.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_task.dart';
import 'package:phan_mem_giao_nhac_viec/services/task/task_service.dart';
import 'package:provider/provider.dart';

class BodyTask extends StatefulWidget {
  const BodyTask({super.key});

  @override
  State<BodyTask> createState() => _BodyTaskState();
}

class _BodyTaskState extends State<BodyTask> {
  final taskService = TaskService();
  // use list object to changeable value after pass to function
  List<DateTime> currentDate = [DateTime.now()];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // get task from database
    SchedulerBinding.instance.addPostFrameCallback((_) {
      GetTaskByDay(context, currentDate[0]);
    });
  }

  GetTaskByDay(BuildContext context, DateTime currentDate) async {
    // show loading indicator
    MyLoadingIndicator(context);
    await taskService.GetTaskByDay(currentDate);
    // close loading indicator
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  RemoveTaskFromDb(String taskId) async {
    try {
      // show loading indicator
      MyLoadingIndicator(context);
      await taskService.RemoveTaskFromDb(taskId, currentDate[0]);
      // close loading indicator
      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      // close loading indicator
      if (context.mounted) {
        Navigator.pop(context);
        // show err dialog
        MyAlertDialog(context, e.toString());
      }
    }
  }

  OpenTaskDetail(ModelTask modelTask, String idTask) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyTaskTileDetail(
          modelTask: modelTask,
          idTask: idTask,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => taskService,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Stack(children: [
                Column(
                  children: [
                    // week calendar
                    WeekCalendar(
                      // pass list object here to can changable value of object
                      currentDate: currentDate,
                    ),
                    TaskTileOverView(),
                  ],
                ),
                // add new task
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Consumer<TaskService>(
                    builder: (context, value, child) {
                      return FloatingActionButton(
                        onPressed: () async {
                          await Navigator.pushNamed(context, "/add_task");
                          // // reload page to load new task
                          if (context.mounted) {
                            GetTaskByDay(context, currentDate[0]);
                          }
                        },
                        child: const Icon(
                          Icons.add,
                        ),
                      );
                    },
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Expanded TaskTileOverView() {
    return Expanded(
      child: Consumer<TaskService>(
        builder: (context, value, child) {
          return value.resultByDate.isEmpty
              ? const Center(
                  child: Text("Nothing to show here!"),
                )
              : ListView.builder(
                  itemCount: value.resultByDate.length,
                  itemBuilder: (context, index) {
                    return MyTaskTileOverview(
                      header: value.resultByDate[index].data()['title'],
                      body: value.resultByDate[index].data()['description'],
                      due: "18 - Nov",
                      onRemove: () =>
                          RemoveTaskFromDb(value.resultByDate[index].id),
                      onTap: () async {
                        await OpenTaskDetail(
                          ModelTask(
                              titleTask:
                                  value.resultByDate[index].data()['title'],
                              descriptionTask: value.resultByDate[index]
                                  .data()['description'],
                              uid: value.resultByDate[index].data()['uid'],
                              createAt:
                                  value.resultByDate[index].data()['createAt'],
                              due: value.resultByDate[index].data()['due']),
                          value.result[index].id,
                        );
                        // reload task
                        value.GetTaskByDay(currentDate[0]);
                      },
                    );
                  },
                );
        },
      ),
    );
  }
}

class WeekCalendar extends StatelessWidget {
  List<DateTime> currentDate;
  WeekCalendar({
    super.key,
    required this.currentDate,
  });

  @override
  Widget build(BuildContext context) {
    final taskService = Provider.of<TaskService>(context, listen: false);
    return HorizontalWeekCalendar(
      onDateChange: (date) {
        currentDate[0] = date;
        log("current date: $currentDate");
        taskService.GetTaskByDay(currentDate[0]);
      },
      initialDate: DateTime.now(),
      minDate: DateTime(2024),
      maxDate: DateTime(2025),
      borderRadius: BorderRadius.circular(8),
      showNavigationButtons: false,
    );
  }
}
