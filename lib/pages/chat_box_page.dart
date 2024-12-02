import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:intl/intl.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_message_tile.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_message.dart';
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

  Future<void> sendMessage(String message) async {
    await ChatService.sendMessage(
        modelMessage: ModelMessage(
            message: message,
            chatCollectionID: widget.chatDocId,
            messageCollection: "Message",
            timeSend: Timestamp.now(),
            senderUID: currentUID));
  }

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
              child: messageStream(),
            ),
            AddVerticalSpace(8),
            bottomBar(messageTextController),
            AddVerticalSpace(8),
          ],
        ),
      ),
    );
  }

  Container bottomBar(TextEditingController messageTextController) {
    return Container(
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: MyTextfield(
              textController: messageTextController,
              textFieldHint: "Enter message here",
            ),
          ),
          IconButton(
              onPressed: () {
                if (messageTextController.text.isNotEmpty) {
                  sendMessage(messageTextController.text);
                  messageTextController.clear();
                }
              },
              icon: Icon(Icons.send_outlined))
        ],
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> messageStream() {
    return StreamBuilder(
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
            Timestamp timeSend = (docs[index].data() as Map)["timeSend"];
            // convert to datetime format
            DateTime convertedTime = timeSend.toDate();
            // convert to HH:mm format
            String formattedTime = DateFormat("HH:mm").format(convertedTime);
            return MyMessageTile(
                text: (docs[index].data() as Map)["message"],
                timeSend: formattedTime,
                bubbleType:
                    // if senderUID of message is equal to current message => set to send bubble type
                    (docs[index].data() as Map)["senderUID"] == currentUID
                        ? BubbleType.sendBubble
                        : BubbleType.receiverBubble);
          },
        );
      },
    );
  }
}
