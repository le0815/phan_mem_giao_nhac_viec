import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/model/task_model.dart';

import 'package:slideable/slideable.dart';

class MyTaskTileOverview extends StatelessWidget {
  final TaskModel modelTask;
  final Color color;
  final Function() onRemove;
  final Function()? onTap;
  const MyTaskTileOverview({
    super.key,
    required this.modelTask,
    required this.onRemove,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Slideable(
              items: [
                ActionItems(
                    icon: const Icon(Icons.delete_outline),
                    onPress: onRemove,
                    backgroudColor: Colors.red[400]!,
                    radius: BorderRadius.circular(12))
              ],
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: color,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        modelTask.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        modelTask.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        modelTask.due == null
                            ? ""
                            : "\nDue: ${DateFormat("HH:mm").format(DateTime.fromMillisecondsSinceEpoch(modelTask.due!))}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
