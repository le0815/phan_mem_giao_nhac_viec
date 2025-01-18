import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/core/theme/theme_config.dart';
import 'package:phan_mem_giao_nhac_viec/core/ultis/ultis.dart';

class MyDatetimeResult extends StatelessWidget {
  const MyDatetimeResult({
    super.key,
    required this.newTime,
    required this.oldTime,
    required this.title,
  });

  final int? newTime;
  final int? oldTime;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: ThemeConfig.secondaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelSmall,
          ),
          Text(
            newTime == null
                ? oldTime == null
                    ? "---"
                    : formatDateTime(
                        pattern: "MM-dd, HH:mm", timeStamp: oldTime!)
                : formatDateTime(pattern: "MM-dd, HH:mm", timeStamp: newTime!),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
