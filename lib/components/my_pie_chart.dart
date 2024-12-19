import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/constraint/constraint.dart';

class MyPieChart extends StatefulWidget {
  const MyPieChart({super.key});

  @override
  State<MyPieChart> createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
  int _touchSection = -1;
  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        // read about it in the PieChartData section
        startDegreeOffset: 270,
        pieTouchData: PieTouchData(
          longPressDuration: const Duration(seconds: 2),
          touchCallback: (FlTouchEvent e, PieTouchResponse? r) {
            if (r == null) {
              return;
            }
            if (r.touchedSection!.touchedSectionIndex == -1) {
              return;
            }
            log("FlTouchEvent: $e");
            log("PieTouchResponse: ${r.touchedSection}");
            setState(() {
              _touchSection = r.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        sections: List.generate(
          MyTaskState.values.length,
          (index) {
            var stateName = MyTaskState.values[index].name;
            return PieChartSectionData(
              value: 25,
              color: myTaskColor[stateName],
              radius: _touchSection == index ? 70 : 50,
              // color: Colors.yellow,
            );
          },
        ),
      ),
      duration: Duration(milliseconds: 150), // Optional
      curve: Curves.linear, // Optional
    );
  }
}
