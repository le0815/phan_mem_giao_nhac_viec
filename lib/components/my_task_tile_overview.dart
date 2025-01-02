import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_task.dart';

import 'package:slideable/slideable.dart';

class MyTaskTileOverview extends StatelessWidget {
  final ModelTask modelTask;
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
                  backgroudColor: Colors.transparent,
                )
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
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        modelTask.description,
                        style: const TextStyle(),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        modelTask.due == null
                            ? ""
                            : "\nDue: ${DateFormat("HH:mm").format(DateTime.fromMillisecondsSinceEpoch(modelTask.due!))}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
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
