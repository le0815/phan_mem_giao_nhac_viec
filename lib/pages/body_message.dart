import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_message_overview_tile.dart';
<<<<<<< HEAD
import 'package:phan_mem_giao_nhac_viec/services/chat/chat_service.dart';
=======
import 'package:phan_mem_giao_nhac_viec/components/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/services/chat/chat_service.dart';
import 'package:phan_mem_giao_nhac_viec/services/database/database_service.dart';
import 'package:phan_mem_giao_nhac_viec/ultis/add_space.dart';
import 'package:provider/provider.dart';
>>>>>>> message

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
<<<<<<< HEAD
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              onPressed: () {
                AddNewChatDialog(context);
              },
              child: const Icon(Icons.add),
            ),
          ),
=======
              bottom: 10,
              right: 10,
              child: FloatingActionButton(
                onPressed: () {
                  AddNewChatDialog(context);
                },
                child: const Icon(Icons.add),
              )),
>>>>>>> message
        ],
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> getChatGroupStream() {
    return StreamBuilder(
      stream: ChatService.groupChatStream(),
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
            return MyMessageOverviewTile(
              chatName: (docs[index].data() as Map?)?["title"],
              msg: (docs[index].data() as Map?)?["msg"],
            );
          },
        );
      },
    );
  }

  Future<dynamic> AddNewChatDialog(BuildContext context) {
<<<<<<< HEAD
=======
    TextEditingController searchPhaseController = TextEditingController();
    TextEditingController chatNameController = TextEditingController();
    var _searchResultProvider = DatabaseService();
>>>>>>> message
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
<<<<<<< HEAD
          title: Text("Add new Chat!"),
          content: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: "Enter chat name",
                ),
              ),
              // search user to add to this chat
              TextField(
                decoration: InputDecoration(
                  hintText: "Search user to add",
                ),
              ),
            ],
=======
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
                                return MyMessageOverviewTile(
                                  chatName: value.result[index].data()["email"],
                                  msg: "sample",
                                );
                              },
                            );
                    },
                  ),
                ),
              ],
            ),
>>>>>>> message
          ),
          // save or cancel action
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
