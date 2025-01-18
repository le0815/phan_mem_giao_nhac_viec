import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/add_space.dart';

class MyMessageOverviewTile extends StatelessWidget {
  final String chatName;
  final String msg;
  const MyMessageOverviewTile({
    super.key,
    required this.chatName,
    required this.msg,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(Icons.people_alt_outlined),
              AddHorizontalSpace(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chatName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(msg),
                ],
              )
            ],
          )),
    );
  }
}
