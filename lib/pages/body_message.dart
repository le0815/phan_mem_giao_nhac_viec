import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_message_overview_tile.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_user_tile_overview.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_chat.dart';
import 'package:phan_mem_giao_nhac_viec/pages/chat_box_page.dart';
import 'package:phan_mem_giao_nhac_viec/services/chat/chat_service.dart';
import 'package:phan_mem_giao_nhac_viec/services/database/database_service.dart';
import 'package:phan_mem_giao_nhac_viec/ultis/add_space.dart';
import 'package:provider/provider.dart';

import '../components/my_alert_dialog.dart';

class BodyMessage extends StatelessWidget {
  const BodyMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Stack(
        children: [
          getChatGroupStream(),
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

  StreamBuilder<QuerySnapshot<Object?>> getChatGroupStream() {
    final currentUID = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder(
      stream: ChatService.groupChatStream(currentUID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          log("loading chat group from database: - ${DateTime.now()}");
          // show loading indicator
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData) {
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
        final docs = snapshot.data!.docs;
        // list message
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              // open chat page
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatBoxPage(
                      chatDocId: docs[index].id,
                      modelChat: ModelChat.fromMap(
                          (docs[index].data() as Map<String, dynamic>)),
                    ),
                  ),
                );
              },
              child: MyMessageOverviewTile(
                chatName: (docs[index].data() as Map?)?["chatName"],
                // (docs[index].data() as Map?)?["msg"]
                msg: "Test",
              ),
            );
          },
        );
      },
    );
  }

  Future<dynamic> AddNewChatDialog(BuildContext context) {
    TextEditingController searchPhaseController = TextEditingController();
    TextEditingController chatNameController = TextEditingController();
    final _userTileGlobalKey = GlobalKey<MyUserTileOverviewState>();
    var iudMember = [FirebaseAuth.instance.currentUser!.uid];

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
                                    userName:
                                        value.result[index].data()["userName"],
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
              onPressed: () {
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
                  ChatService.createNewChat(
                    chatName: chatNameController.text.trim(),
                    members: iudMember,
                    timeUpdate: Timestamp.now(),
                  );
                  Navigator.pop(context);
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
