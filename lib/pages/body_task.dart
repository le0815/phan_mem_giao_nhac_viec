import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:horizontal_week_calendar/horizontal_week_calendar.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_loading_indicator.dart';
import 'package:phan_mem_giao_nhac_viec/pages/add_task.dart';
import 'package:phan_mem_giao_nhac_viec/pages/detail_task_page.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_task_tile_overview.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_task.dart';
import 'package:phan_mem_giao_nhac_viec/services/task/task_service.dart';

class BodyTask extends StatefulWidget {
  const BodyTask({super.key});

  @override
  State<BodyTask> createState() => _BodyTaskState();
}

class _BodyTaskState extends State<BodyTask> {
  final taskService = TaskService();
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
      await taskService.RemoveTaskFromDb(taskId, currentDate);
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
                      maxDate: DateTime(2025),
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

  Expanded TaskTileOverView() {
    return Expanded(
      child: FutureBuilder<Map>(
        future: taskService.GetTaskByDay(currentDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MyLoadingIndicator();
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text("Nothing to show here!"),
            );
          }
          var result = snapshot.data!;
          return ListView.builder(
            itemCount: result.length,
            itemBuilder: (context, index) {
              return MyTaskTileOverview(
                header: result[index].data()['title'],
                body: result[index].data()['description'],
                due: "18 - Nov",
                onRemove: () async {
                  await RemoveTaskFromDb(result[index].id);
                  setState(() {});
                },
                onTap: () async {
                  await OpenTaskDetail(
                    ModelTask(
                        title: result[index].data()['title'],
                        description: result[index].data()['description'],
                        uid: result[index].data()['uid'],
                        createAt: result[index].data()['createAt'],
                        due: result[index].data()['due']),
                    result[index].id,
                  );
                  // reload task overview
                  setState(() {});
                },
              );
            },
          );
        },
      ),
    );
  }
}
