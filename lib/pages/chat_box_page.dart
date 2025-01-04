import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_message_tile.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/constraint/constraint.dart';
import 'package:phan_mem_giao_nhac_viec/local_database/hive_boxes.dart';
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
  final ScrollController _scrollController = ScrollController();
  bool isSending = false;
  ModelUser? modelMember;
  getModelMember() async {
    var memberUID = widget.modelChat.members
        .where(
          (element) => element != currentUID,
        )
        .toString()
        .replaceAll(RegExp(r'[()]'), '');

    modelMember = await DatabaseService.instance.getUserByUID(memberUID);
  }

  @override
  void initState() {
    super.initState();
    getModelMember();
  }

  Future<void> sendMessage(String message) async {
    // set state to show the loading indicator
    setState(() {
      isSending = true;
    });
    // store message to firebase
    await ChatService.instance.sendMessage(
      chatDocID: widget.chatDocId,
      modelMessage: ModelMessage(
        message: message,
        timeSend: DateTime.now().millisecondsSinceEpoch,
        senderUID: currentUID,
      ),
    );
    log("fcm member: ${modelMember!.fcm}");

    // notify to user in chat box
    NotificationService.instance.sendNotification(
        receiverToken: modelMember!.fcm,
        title: "You have new message from ${modelMember!.userName}",
        body: message,
        payload: {
          "notificationType": "remote",
          '0': SyncTypes.syncMessage,
        });

    // sync message into hive
    log("sync new message sent");
    await HiveBoxes.instance.syncData(syncType: SyncTypes.syncMessage);

    setState(() {
      isSending = false;
    });
  }

  scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
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
              child: Stack(
                children: [
                  MessageHiveStream(
                    scrollController: _scrollController,
                    chatDocId: widget.chatDocId,
                    currentUID: currentUID,
                  ),
                  // scroll down button
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: IconButton(
                      onPressed: () {
                        // scroll down till the end of chat
                        scrollDown();
                      },
                      icon: const Icon(Icons.arrow_circle_down_sharp),
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
          // send message button
          isSending
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                )
              : IconButton(
                  onPressed: () async {
                    if (messageTextController.text.isNotEmpty) {
                      await sendMessage(messageTextController.text);
                      // clear the text in textfield
                      messageTextController.clear();
                      // scroll down
                      scrollDown();
                    }
                  },
                  icon: const Icon(Icons.send_outlined),
                ),
        ],
      ),
    );
  }
}

class MessageHiveStream extends StatelessWidget {
  final ScrollController scrollController;
  final String chatDocId;
  final String currentUID;
  const MessageHiveStream(
      {super.key,
      required this.scrollController,
      required this.chatDocId,
      required this.currentUID});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HiveBoxes.instance.chatHiveBox.listenable(),
      builder: (context, value, child) {
        Map messageData = value.toMap()[chatDocId]["modelMessages"];
        if (messageData.isEmpty) {
          return const Center(
            child: Text("Empty message!"),
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
