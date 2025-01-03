import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_pie_chart.dart';
import 'package:phan_mem_giao_nhac_viec/constraint/constraint.dart';
import 'package:phan_mem_giao_nhac_viec/services/background_service/background_service.dart';
import 'package:phan_mem_giao_nhac_viec/services/notification_service/notification_service.dart';
import 'package:phan_mem_giao_nhac_viec/ultis/add_space.dart';
import 'package:workmanager/workmanager.dart';

import '../components/my_legend_chart.dart';
import '../local_database/hive_boxes.dart';
import '../services/database/database_service.dart';

class BodyHome extends StatelessWidget {
  const BodyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          // Overview
          OverView(),
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

  Container TodayTask() {
    String currentDay = DateFormat('dd MMMM').format(DateTime.now());
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // date today will display here
          Row(
            children: [
              Text(
                "Today - $currentDay",
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
          ListTile(
            leading: const Icon(Icons.circle),
            title: const Text("Home"),
          ),
        ],
      ),
    );
  }
}

class OverView extends StatefulWidget {
  const OverView({
    super.key,
  });

  @override
  State<OverView> createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      // color: Colors.blue,
      child: Column(
        children: [
          const Row(
            children: [
              Text("Overview", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(
            thickness: 1,
            color: Colors.black,
          ),
          const chatLegend(),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: HiveBoxes.instance.taskHiveBox.listenable(),
              builder: (context, box, child) {
                if (box.isEmpty) {
                  return const Center(
                    child: Text("Nothing to show here!"),
                  );
                }

                var classifiedTask = DatabaseService.instance
                    .taskClassification(data: box.toMap());
                return MyPieChart(
                  taskData: classifiedTask,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class chatLegend extends StatelessWidget {
  const chatLegend({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            myLegendChart(annotation: "Pending", color: Colors.yellow),
            myLegendChart(annotation: "In progress", color: Colors.blue),
          ],
        ),
        AddHorizontalSpace(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            myLegendChart(annotation: "Completed", color: Colors.green),
            myLegendChart(annotation: "Over due", color: Colors.red),
          ],
        ),
      ],
    );
  }
}
