import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:horizontal_week_calendar/horizontal_week_calendar.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_loading_indicator.dart';
import 'package:phan_mem_giao_nhac_viec/pages/detail_task_page.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_task_tile_overview.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_task.dart';
import 'package:phan_mem_giao_nhac_viec/pages/add_task.dart';
import 'package:phan_mem_giao_nhac_viec/services/task/task_service.dart';
import 'package:provider/provider.dart';

class BodyTask extends StatefulWidget {
  const BodyTask({super.key});

  @override
  State<BodyTask> createState() => _BodyTaskState();
}

class _BodyTaskState extends State<BodyTask> {
  final taskService = TaskService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // get task from database
    SchedulerBinding.instance.addPostFrameCallback((_) {
      GetTaskFromDb(context);
    });
  }

  GetTaskFromDb(BuildContext context) async {
    // show loading indicator
    MyLoadingIndicator(context);
    await taskService.GetTaskFromDb();
    // close loading indicator
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  RemoveTaskFromDb(String taskId) async {
    try {
      // show loading indicator
      MyLoadingIndicator(context);
      await taskService.RemoveTaskFromDb(taskId);
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
                    WeekCalendar(),
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
                            GetTaskFromDb(context);
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
          return ListView.builder(
            itemCount: value.result.length,
            itemBuilder: (context, index) {
              return MyTaskTileOverview(
                header: value.result[index].data()['title'],
                body: value.result[index].data()['description'],
                due: "18 - Nov",
                onRemove: () => RemoveTaskFromDb(value.result[index].id),
                onTap: () async {
                  await OpenTaskDetail(
                    ModelTask(
                        titleTask: value.result[index].data()['title'],
                        descriptionTask:
                            value.result[index].data()['description'],
                        uid: value.result[index].data()['uid'],
                        createAt: value.result[index].data()['createAt'],
                        due: value.result[index].data()['due']),
                    value.result[index].id,
                  );
                  value.GetTaskFromDb();
                },
              );
            },
          );
        },
      ),
    );
  }

  HorizontalWeekCalendar WeekCalendar() {
    return HorizontalWeekCalendar(
      initialDate: DateTime.now(),
      minDate: DateTime(2024),
      maxDate: DateTime(2025),
      borderRadius: BorderRadius.circular(8),
      showNavigationButtons: false,
    );
  }
}
