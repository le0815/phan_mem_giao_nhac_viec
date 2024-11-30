import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/ultis/add_space.dart';

class BodyHome extends StatelessWidget {
  const BodyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          // search box
          SearchBox(),
          AddVerticalSpace(20),
          // today task
          TodayTask(),
          AddVerticalSpace(16),
          // Overview
          OverView()
        ],
      ),
    );
  }

  TextField SearchBox() {
    return TextField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 0),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        hintText: "Search",
        hintStyle: const TextStyle(color: Colors.black38),
        filled: true,
        fillColor: Colors.grey[350]!.withOpacity(0.6),
      ),
    );
  }

  Expanded OverView() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(top: 8, left: 12, right: 12, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          children: [
            Row(
              children: [
                Text("Overview", style: TextStyle(fontWeight: FontWeight.bold)),
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
    );
  }

  Container TodayTask() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        children: [
          // date today will display here
          Row(
            children: [
              Text(
                "Today - 13 Nov",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          //divider
          Divider(
            thickness: 1,
            color: Colors.black54,
          ),
          Text("Your today task will be display here"),
        ],
      ),
    );
  }
}
