import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_doughnutchart.dart';
import 'package:phan_mem_giao_nhac_viec/ultis/add_space.dart';

class BodyHome extends StatelessWidget {
  const BodyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          // search box
          TextField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 0),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              hintText: "Search",
              hintStyle: TextStyle(color: Colors.black38),
              filled: true,
              fillColor: Colors.grey[350]!.withOpacity(0.6),
            ),
          ),
          AddVerticalSpace(20),
          // today task
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              children: [
                // date today will display here
                Row(
                  children: [Text("Today - 13 Nov")],
                ),
                //divider
                Divider(
                  thickness: 1,
                  color: Colors.black54,
                ),
                Text("Your today task will be display here"),
              ],
            ),
          ),
          AddVerticalSpace(16),
          // Overview
          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.only(top: 8, left: 12, right: 12, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Row(
                    children: [
                      Text("Overview"),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.black,
                  ),
                  // MyDoughnutchart(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
