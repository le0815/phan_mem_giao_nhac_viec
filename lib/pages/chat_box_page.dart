import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_message_tile.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/services/chat/chat_service.dart';
import 'package:phan_mem_giao_nhac_viec/ultis/add_space.dart';

class ChatBoxPage extends StatefulWidget {
  final String chatDocId;
  const ChatBoxPage({super.key, required this.chatDocId});

  @override
  State<ChatBoxPage> createState() => _ChatBoxPageState();
}

class _ChatBoxPageState extends State<ChatBoxPage> {
  final String currentUID = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    TextEditingController messageTextController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat name"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: ChatService.messageStream(widget.chatDocId),
                builder: (context, snapshot) {
                  // show loading indicator
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  // if have no data
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text("Empty message!"),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      return MyMessageTile(
                          text: (docs[index].data() as Map)["message"],
                          bubbleType:
                              // if senderUID of message is equal to current message => set to send bubble type
                              (docs[index].data() as Map)["senderUID"]
                                          .toString() ==
                                      currentUID.toString()
                                  ? BubbleType.sendBubble
                                  : BubbleType.receiverBubble);
                    },
                  );
                },
              ),
            ),
            Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  Expanded(
                    child: MyTextfield(
                      textController: messageTextController,
                      textFieldHint: "Enter message here",
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.send_outlined))
                ],
              ),
            ),
            AddVerticalSpace(8),
          ],
        ),
      ),
    );
  }
}
