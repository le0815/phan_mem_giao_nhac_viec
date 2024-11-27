import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_message_overview_tile.dart';

class BodyMessage extends StatelessWidget {
  const BodyMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Stack(
        children: [
          // list message
          ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) {
              return const MyMessageOverviewTile(
                chatName: "Test Chat Name",
                msg: "test msg 😍",
              );
            },
          ),
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
