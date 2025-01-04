import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_message_overview_tile.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_user_tile_overview.dart';
import 'package:phan_mem_giao_nhac_viec/constraint/constraint.dart';
import 'package:phan_mem_giao_nhac_viec/local_database/hive_boxes.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_chat.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_user.dart';
import 'package:phan_mem_giao_nhac_viec/pages/chat_box_page.dart';
import 'package:phan_mem_giao_nhac_viec/services/chat/chat_service.dart';
import 'package:phan_mem_giao_nhac_viec/services/database/database_service.dart';
import 'package:phan_mem_giao_nhac_viec/ultis/add_space.dart';
import 'package:provider/provider.dart';

import '../components/my_alert_dialog.dart';
import '../services/notification_service/notification_service.dart';

class BodyMessage extends StatelessWidget {
  const BodyMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Stack(
        children: [
          const GetChatGroup(),
          // float add new chat button
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              onPressed: () {
                AddNewChatDialog(context);
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> AddNewChatDialog(BuildContext context) {
    TextEditingController searchPhaseController = TextEditingController();
    TextEditingController chatNameController = TextEditingController();
    final _userTileGlobalKey = GlobalKey<MyUserTileOverviewState>();
    var iudMember = [FirebaseAuth.instance.currentUser!.uid];
    ModelUser? modelUserMemberChat;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add new Chat!"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // chat name text field
                MyTextfield(
                  textController: chatNameController,
                  textFieldHint: "Enter chat name",
                ),
                AddVerticalSpace(10),
                // enter user searchPhase
                Consumer<DatabaseService>(
                  builder: (context, value, child) {
                    return MyTextfield(
                      textController: searchPhaseController,
                      textFieldHint: "Search user to add",
                      prefixIcon: const Icon(Icons.search_outlined),
                      onPressed: () {
                        value.searchUser(searchPhaseController.text);
                      },
                    );
                  },
                ),
                AddVerticalSpace(10),
                // query user to add to this chat
                SizedBox(
                  width: double.maxFinite,
                  height: 300,
                  child: Consumer<DatabaseService>(
                    builder: (context, value, child) {
                      return value.result.isEmpty
                          ? const Text("Try search something!")
                          : ListView.builder(
                              itemCount: value.result.length,
                              itemBuilder: (context, index) {
                                modelUserMemberChat = ModelUser.fromMap(
                                    value.result[index].data());
                                return GestureDetector(
                                  onTap: () {
                                    // change color of user tile when tapped
                                    final userTile =
                                        _userTileGlobalKey.currentState!;
                                    userTile.changeState();
                                    // add uid to members of chat
                                    iudMember
                                        .add(value.result[index].id.toString());
                                  },
                                  child: MyUserTileOverview(
                                    key: _userTileGlobalKey,
                                    userName: modelUserMemberChat!.userName,
                                    msg: "sample",
                                    onRemove: () {},
                                  ),
                                );
                              },
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
          // save or cancel action
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                var userTile = _userTileGlobalKey.currentState;

                /// if user was not selected -> show alert
                if (userTile == null || userTile.widget.isSelected == false) {
                  MyAlertDialog(
                    context,
                    msg: "User must be selected",
                    onOkay: () => Navigator.pop(context),
                  );
                } else {
                  // add chat to database
                  await ChatService.instance.createNewChat(
                    chatName: chatNameController.text.trim(),
                    members: iudMember,
                    timeUpdate: Timestamp.now().millisecondsSinceEpoch,
                  );
                  Navigator.pop(context);
                  // sync chat data
                  log("sync chat data from add new chat");
                  HiveBoxes.instance.syncData(syncType: SyncTypes.syncMessage);
                  NotificationService.instance.sendNotification(
                      receiverToken: modelUserMemberChat!.fcm,
                      title:
                          "You have a new chat with ${modelUserMemberChat!.userName}!",
                      payload: {
                        "notificationType": "remote",
                        "0": SyncTypes.syncMessage,
                      });
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}

class GetChatGroup extends StatefulWidget {
  const GetChatGroup({super.key});

  @override
  State<GetChatGroup> createState() => _GetChatGroupState();
}

class _GetChatGroupState extends State<GetChatGroup> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HiveBoxes.instance.chatHiveBox.listenable(),
      builder: (context, value, child) {
        if (value.isEmpty) {
          return const Center(
            child: Text(
              'No message here',
              style: TextStyle(
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
                    ),
                  ),
                );
              },
              child: MyMessageOverviewTile(
                chatName: modelChat.chatName,
                // (docs[index].data() as Map?)?["msg"]
                msg: "Test",
              ),
            );
          },
        );
      },
    );
  }
}
