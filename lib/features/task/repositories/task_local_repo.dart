import 'package:phan_mem_giao_nhac_viec/core/repositories/local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/model/task_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/repositories/task_remote_repo.dart';

class TaskLocalRepo {
  static final TaskLocalRepo instance = TaskLocalRepo._();
  final taskHiveBox = LocalRepo.instance.taskHiveBox;
  TaskLocalRepo._();
  syncData() async {
    // get data from database
    var data = await TaskRemoteRepo.instance.GetTaskFromDb();
    // clear the previous data
    await taskHiveBox.clear();
    // sync data
    taskHiveBox.putAll(data);
  }

// get all task
  taskClassification({required Map<dynamic, dynamic> data}) {
    Map result = {};
    // classification state of task by group
    // processed data will be like this
    // {
    //   taskState1: {
    //     docIDTask1: modelTask1,
    //     docIDTask2: modelTask2,
    //     ....
    //   }
    //   taskState2: {
    //     docIDTask3: modelTask3,
    //     docIDTask4: modelTask4,
    //     ....
    //   }
    // }
    data.forEach(
      (key, value) {
        var modelTask = TaskModel.fromMap(value);
        if (result[modelTask.state] != null) {
          result[modelTask.state].addAll({key: modelTask});
        } else {
          result[modelTask.state] = {key: modelTask};
        }
      },
    );
    return result;
  }

  Map<String, TaskModel> getTaskByDay({required DateTime currentDay}) {
    var resultByDate = <String, TaskModel>{};
    var dateOnlyCurrentTime = ConvertToDateOnly(currentDay);

    // loop to get task with due time is bigger or equal to the current time
    taskHiveBox.toMap().forEach(
      (key, value) {
        TaskModel modelTask = TaskModel.fromMap(value);
        // if the task was not provide due time -> add
        if (modelTask.due == null) {
          resultByDate.addAll(
            {
              key: modelTask,
            },
          );
        } else {
          // convert due time to date only
          var dateOnlyDueTimeOfTask = ConvertToDateOnly(
              DateTime.fromMillisecondsSinceEpoch(modelTask.due!));
          // convert due time to date only
          var dateOnlyCreateTimeOfTask = ConvertToDateOnly(
              DateTime.fromMillisecondsSinceEpoch(modelTask.startTime!));
          // if due, create time is greater or equal than current day
          if (dateOnlyCurrentTime.compareTo(dateOnlyDueTimeOfTask) != 1 &&
              dateOnlyCurrentTime.compareTo(dateOnlyCreateTimeOfTask) != -1) {
            resultByDate.addAll(
              {
                key: modelTask,
              },
            );
          }
        }
      },
    );
    return resultByDate;
  }

  DateTime convertToDateOnly(DateTime time) {
    return time.copyWith(
        hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
  }
}
