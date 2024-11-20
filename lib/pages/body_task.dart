import 'package:flutter/material.dart';
import 'package:horizontal_week_calendar/horizontal_week_calendar.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_task_overview.dart';

class BodyTask extends StatefulWidget {
  const BodyTask({super.key});

  @override
  State<BodyTask> createState() => _BodyTaskState();
}

class _BodyTaskState extends State<BodyTask> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: Stack(children: [
              Column(
                children: [
                  // week calendar
                  WeekCalendar(),
                  TaskOverView(),
                ],
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: FloatingActionButton(
                  onPressed: () {},
                  child: Icon(
                    Icons.add,
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Expanded TaskOverView() {
    return Expanded(
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return const MyTaskOverview(
            header: "Test",
            body:
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
            due: "18 - Nov",
          );
        },
      ),
    );
  }

  HorizontalWeekCalendar WeekCalendar() {
    return HorizontalWeekCalendar(
      initialDate: DateTime.now(),
      minDate: DateTime(2024),
      maxDate: DateTime(2025),
      borderRadius: BorderRadius.circular(8),
      showNavigationButtons: false,
    );
  }
}
