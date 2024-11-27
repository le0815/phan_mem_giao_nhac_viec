import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_message_overview_tile.dart';

class BodyMessage extends StatelessWidget {
  const BodyMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListView.builder(
          itemCount: 4,
          itemBuilder: (context, index) {
            return const MyMessageOverviewTile(
              chatName: "Test Chat Name",
              msg: "test msg 😍",
            );
          },
        ),
    );
  }
}
