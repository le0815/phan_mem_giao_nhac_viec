import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:phan_mem_giao_nhac_viec/ultis/add_space.dart';
import 'package:slideable/slideable.dart';

class MyTaskOverview extends StatelessWidget {
  final String header;
  final String body;
  final String due;
  const MyTaskOverview({
    super.key,
    required this.header,
    required this.body,
    required this.due,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Slideable(
              backgroundColor: const Color.fromARGB(0, 255, 255, 255),
              items: [
                ActionItems(
                    icon: const Icon(Icons.delete_outline), onPress: () {})
              ],
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.amber[200],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      header,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      body,
                      style: const TextStyle(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "\nDue: $due",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
