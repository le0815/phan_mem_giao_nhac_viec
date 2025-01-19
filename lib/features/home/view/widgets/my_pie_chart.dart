import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/core/constraint/constraint.dart';
import 'package:phan_mem_giao_nhac_viec/features/home/view/pages/detail_section_piechart.dart';

class MyPieChart extends StatefulWidget {
  final Map<dynamic, dynamic> taskData;
  const MyPieChart({super.key, required this.taskData});

  @override
  State<MyPieChart> createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
  int _touchSection = -1;

  @override
  Widget build(BuildContext context) {
    int totalTasks = 0;
    widget.taskData.forEach(
      (key, value) {
        totalTasks += widget.taskData[key].length as int;
      },
    );

    return Stack(children: [
      PieChart(
        PieChartData(
          // read about it in the PieChartData section
          startDegreeOffset: 270,
          pieTouchData: PieTouchData(
            longPressDuration: const Duration(seconds: 1),
            touchCallback: (FlTouchEvent e, PieTouchResponse? r) async {
              if (r == null) {
                return;
              }
              if (r.touchedSection!.touchedSectionIndex == -1) {
                return;
              }
              log("FlTouchEvent: $e");
              log("PieTouchResponse: ${r.touchedSection!.touchedSection!.data}");
              // if detected long press event => go to sections detail page
              if (e is FlLongPressStart) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailSectionPieChart(
                      modelTasks: r.touchedSection!.touchedSection!.data!,
                    ),
                  ),
                );
                setState(() {});
              }
              setState(() {
                _touchSection = r.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          // generate data sections from task fetched from firebase
          /// IMPORTANCE
          /// you must modify PieChartSectionData class by
          /// - add 'final Map<String, dynamic>? data' attribute
          /// - add 'this.data' in the constructor
          /// - 'Map<String, dynamic>? data' and 'data: data' in the copyWith func
          sections: List.generate(
            widget.taskData.length,
            (index) {
              var currentTaskStateKey = widget.taskData.keys.elementAt(index);
              var taskStateCount = widget.taskData[currentTaskStateKey].length;
              return PieChartSectionData(
                value: taskStateCount / totalTasks,
                color: myTaskColor[widget.taskData.keys.elementAt(index)],
                radius: _touchSection == index ? 70 : 50,
                title: "",
                data: (widget.taskData[currentTaskStateKey] as Map)
                    .cast<String, dynamic>(),
                // color: Colors.yellow,
              );
            },
          ),
        ),
        duration: const Duration(milliseconds: 150), // Optional
        curve: Curves.linear, // Optional
      ),
      // totalTasks
      Center(
        child: Text("$totalTasks Totals"),
      )
    ]);
  }
}
