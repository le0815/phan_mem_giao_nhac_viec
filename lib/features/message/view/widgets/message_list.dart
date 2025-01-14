import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:phan_mem_giao_nhac_viec/core/repositories/local_repo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phan_mem_giao_nhac_viec/features/message/models/model_message.dart';
import 'package:phan_mem_giao_nhac_viec/features/message/view/widgets/my_message_tile.dart';

class MessageList extends StatelessWidget {
  final ScrollController scrollController;
  final String chatDocId;
  final String currentUID;
  const MessageList(
      {super.key,
      required this.scrollController,
      required this.chatDocId,
      required this.currentUID});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: LocalRepo.instance.chatHiveBox.listenable(),
      builder: (context, value, child) {
        Map messageData = value.toMap()[chatDocId]["modelMessages"];
        if (messageData.isEmpty) {
          return Center(
            child: Text(AppLocalizations.of(context)!.emptyMessage),
          );
        }

        return ListView.builder(
          controller: scrollController,
          itemCount: messageData.length,
          itemBuilder: (context, index) {
            ModelMessage modelMessage =
                ModelMessage.fromMap(messageData.values.elementAt(index));

            // convert to datetime format
            DateTime convertedTime =
                DateTime.fromMillisecondsSinceEpoch(modelMessage.timeSend);
            // convert to HH:mm format
            String formattedTime = DateFormat("HH:mm").format(convertedTime);
            return MyMessageTile(
              text: modelMessage.message,
              timeSend: formattedTime,
              bubbleType:
                  // if senderUID of message is equal to current message => set to send bubble type
                  (modelMessage.senderUID == currentUID
                      ? BubbleType.sendBubble
                      : BubbleType.receiverBubble),
            );
          },
        );
      },
    );
  }
}
