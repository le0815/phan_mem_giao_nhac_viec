import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phan_mem_giao_nhac_viec/features/message/models/model_chat.dart';
import 'package:phan_mem_giao_nhac_viec/features/message/repositories/message_local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/features/message/view/pages/chat_box_page.dart';
import 'package:phan_mem_giao_nhac_viec/features/message/view/widgets/chat_box_overview.dart';
import 'package:phan_mem_giao_nhac_viec/features/message/view_model/message_view_model.dart';

class ChatBoxList extends StatelessWidget {
  const ChatBoxList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: MessageLocalRepo.instance.messageHiveBox.listenable(),
      builder: (context, value, child) {
        if (value.isEmpty) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.noMessageHere,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black54,
              ),
            ),
          );
        }
        var chatData = value.toMap();
        // list message
        return ListView.builder(
          itemCount: chatData.length,
          itemBuilder: (context, index) {
            ModelChat modelChat = ModelChat.fromMap(
                chatData.values.elementAt(index)["modelChat"]);
            var idChat = chatData.keys.elementAt(index);

            return GestureDetector(
              // open chat page
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatBoxPage(
                      chatDocId: idChat,
                      modelChat: modelChat,
                      memberUserModel: MessageViewModel.instance
                          .getMemberModelUser(modelChat: modelChat),
                    ),
                  ),
                );
              },
              child: ChatBoxOverview(
                chatName: modelChat.chatName,
                // (docs[index].data() as Map?)?["msg"]
                modelMessage: MessageViewModel.instance.getLatestMessageOfChat(
                  chatData: chatData.values.elementAt(index),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
