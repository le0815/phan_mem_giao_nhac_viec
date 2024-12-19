import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:intl/intl.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_message_tile.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_chat.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_message.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_user.dart';
import 'package:phan_mem_giao_nhac_viec/services/chat/chat_service.dart';
import 'package:phan_mem_giao_nhac_viec/services/database/database_service.dart';
import 'package:phan_mem_giao_nhac_viec/services/notification_service/notification_service.dart';
import 'package:phan_mem_giao_nhac_viec/ultis/add_space.dart';

class ChatBoxPage extends StatefulWidget {
  final String chatDocId;
  final ModelChat modelChat;
  const ChatBoxPage(
      {super.key, required this.chatDocId, required this.modelChat});

  @override
  State<ChatBoxPage> createState() => _ChatBoxPageState();
}

class _ChatBoxPageState extends State<ChatBoxPage> {
  final String currentUID = FirebaseAuth.instance.currentUser!.uid;
  ModelUser? modelMember;
  getModelMember() async {
    var memberUID = widget.modelChat.members
        .where(
          (element) => element != currentUID,
        )
        .toString()
        .replaceAll(RegExp(r'[()]'), '');

    modelMember = await DatabaseService().getUserByUID(memberUID);
  }

  @override
  void initState() {
    super.initState();
    getModelMember();
  }

  Future<void> sendMessage(String message) async {
    await ChatService.sendMessage(
      modelMessage: ModelMessage(
          message: message,
          chatCollectionID: widget.chatDocId,
          messageCollection: "Message",
          timeSend: Timestamp.now(),
          senderUID: currentUID),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController messageTextController = TextEditingController();
    final ScrollController _scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat name"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  messageStream(_scrollController),
                  // scroll down button
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: IconButton(
                      onPressed: () {
                        // scroll down till the end of chat
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(seconds: 1),
                          curve: Curves.fastOutSlowIn,
                        );
                      },
                      icon: Icon(Icons.arrow_circle_down_sharp),
                    ),
                  )
                ],
              ),
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
                  log("fcm member: ${modelMember!.fcm}");

                  // notify to user in chat box
                  NotificationService.instance.sendNotification(
                    receiverToken: modelMember!.fcm,
                    title: "You have new message from ${modelMember!.userName}",
                    body: messageTextController.text,
                  );

                  messageTextController.clear();
                }
              },
              icon: Icon(Icons.send_outlined))
        ],
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> messageStream(
      ScrollController scrollController) {
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
          controller: scrollController,
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
