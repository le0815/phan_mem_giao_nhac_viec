import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/features/message/view/widgets/bottom_message_bar.dart';
import 'package:phan_mem_giao_nhac_viec/features/message/view/widgets/message_list.dart';
import 'package:phan_mem_giao_nhac_viec/features/message/view_model/message_view_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/user/model/user_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/message/models/model_chat.dart';

import 'package:phan_mem_giao_nhac_viec/core/widgets/add_space.dart';

class ChatBoxPage extends StatefulWidget {
  final String chatDocId;
  final ModelChat modelChat;
  final UserModel memberUserModel;
  final TextEditingController messageTextController = TextEditingController();
  ChatBoxPage({
    super.key,
    required this.chatDocId,
    required this.modelChat,
    required this.memberUserModel,
  });

  @override
  State<ChatBoxPage> createState() => _ChatBoxPageState();
}

class _ChatBoxPageState extends State<ChatBoxPage> {
  final String currentUID = FirebaseAuth.instance.currentUser!.uid;
  final ScrollController _scrollController = ScrollController();
  bool isSending = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure the widget is fully initialized
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // Defer showing the dialog until after the current frame
      scrollDown();
    });
  }

  sendMessage(String message) async {
    // set state to show the loading indicator
    setState(() {
      isSending = true;
    });
    try {
      await MessageViewModel.instance.sendMessage(
          message: message,
          memberUserModel: widget.memberUserModel,
          chatDocID: widget.chatDocId);
      widget.messageTextController.clear();

      scrollDown();
    } catch (e) {
      MyAlertDialog(
        context: context,
        msg: "error while sending message: $e",
      );
    }
    setState(() {
      isSending = false;
    });
  }

  scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOutSine,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat name"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  MessageList(
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
            BottomMessageBar(
              chatBoxPageWidget: widget,
              isSending: isSending,
              onPressed: () async =>
                  await sendMessage(widget.messageTextController.text),
            ),
            AddVerticalSpace(8),
          ],
        ),
      ),
    );
  }
}
