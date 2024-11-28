import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_message_overview_tile.dart';
import 'package:phan_mem_giao_nhac_viec/services/chat/chat_service.dart';

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
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
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
