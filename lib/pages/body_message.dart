import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_message_overview_tile.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_textfield.dart';
import 'package:phan_mem_giao_nhac_viec/services/chat/chat_service.dart';
import 'package:phan_mem_giao_nhac_viec/services/database/database_service.dart';
import 'package:phan_mem_giao_nhac_viec/ultis/add_space.dart';
import 'package:provider/provider.dart';

class BodyMessage extends StatelessWidget {
  const BodyMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DatabaseService>(
      create: (context) => DatabaseService(),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Stack(
          children: [
            getChatGroupStream(),
            // float add new chat button
            Positioned(
              bottom: 10,
              right: 10,
              child: Consumer<DatabaseService>(
                builder: (context, value, child) {
                  return FloatingActionButton(
                    onPressed: () {
                      AddNewChatDialog(context, value);
                    },
                    child: const Icon(Icons.add),
                  );
                },
              ),
            ),
          ],
        ),
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

  Future<dynamic> AddNewChatDialog(BuildContext context, var value) {
    TextEditingController searchPhaseController = TextEditingController();
    TextEditingController chatNameController = TextEditingController();
    var _searchResultProvider = DatabaseService();
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
                // search user to add to this chat
                MyTextfield(
                  textController: searchPhaseController,
                  textFieldHint: "Search user to add",
                  prefixIcon: const Icon(Icons.search_outlined),
                  onPressed: () {
                    _searchResultProvider
                        .searchUser(searchPhaseController.text);
                  },
                ),
                // query user to add to this chat
                SizedBox(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    child: value.result.isEmpty
                        ? const Text("Nothing to show here!")
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: value.result.length,
                            itemBuilder: (context, index) {
                              return MyMessageOverviewTile(
                                chatName: (value.result[index].data()
                                    as Map?)?["email"],
                                msg: "sample",
                              );
                            },
                          ))
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
              onPressed: () => Navigator.pop(context),
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
