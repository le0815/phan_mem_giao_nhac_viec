import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MyDoughnutchart extends StatelessWidget {
  const MyDoughnutchart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // label doughnut segment
        Row(
          children: [
            // label doughnut segment
            Container(
              width: 27,
              height: 13,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            const Text("Completed"),
            const SizedBox(
              width: 12,
            ),
            // label doughnut segment
            Container(
              width: 27,
              height: 13,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            const Text("Doing"),

            const SizedBox(
              width: 12,
            ),
            // label doughnut segment
            Container(
              width: 27,
              height: 13,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            const Text("Over due"),
          ],
        ),
        SfRadialGauge(
          axes: [
            RadialAxis(
              radiusFactor: 0.65,
              axisLineStyle: AxisLineStyle(
                thickness: 25,
                color: const Color.fromARGB(15, 0, 0, 0),
              ),
              startAngle: 270,
              endAngle: 270,
              showLabels: false,
              showTicks: false,
            ),
            RadialAxis(
              radiusFactor: 0.65,
              pointers: const [
                RangePointer(
                  value: 15,
                  color: Colors.green,
                  width: 25,
                )
              ],
              startAngle: 270,
              endAngle: 270,
              showLabels: false,
              showTicks: false,
              showAxisLine: false,
            ),
            RadialAxis(
              radiusFactor: 0.65,
              pointers: const [
                RangePointer(
                  value: 50,
                  color: Colors.blue,
                  width: 25,
                )
              ],
              startAngle: 40,
              endAngle: 270,
              showLabels: false,
              showTicks: false,
              showAxisLine: false,
            ),
          ],
        )
      ],
    );
  }
}
