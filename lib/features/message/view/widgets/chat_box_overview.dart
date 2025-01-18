import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/core/theme/theme_config.dart';
import 'package:phan_mem_giao_nhac_viec/core/ultis/ultis.dart';
import 'package:phan_mem_giao_nhac_viec/features/message/models/model_message.dart';

class ChatBoxOverview extends StatelessWidget {
  final String chatName;
  // latest message
  final ModelMessage? modelMessage;
  const ChatBoxOverview({
    super.key,
    required this.chatName,
    required this.modelMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ThemeConfig.secondaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chatName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  modelMessage?.message ?? "",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            Text(
              modelMessage == null
                  ? ""
                  : formatDateTime(
                          pattern: "HH:mm", timeStamp: modelMessage!.timeSend)
                      .toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
