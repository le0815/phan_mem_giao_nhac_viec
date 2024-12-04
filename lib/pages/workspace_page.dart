import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_loremipsum.dart';
import 'package:provider/provider.dart';

class WorkspacePage extends StatefulWidget {
  const WorkspacePage({super.key});

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  final _now = DateTime.now();
  List<CalendarEventData> _events = [
    CalendarEventData(
      date: DateTime.now(),
      title: "Project meeting",
      description: "Today is project meeting.",
      startTime: DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 18, 30),
      endTime: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 22),
    ),
  ];
  final event = CalendarEventData(
    date: DateTime.now(),
    title: "Project meeting",
    description: "Today is project meeting.",
    startTime: DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 18, 30),
    endTime: DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 22),
  );

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: EventController(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Workspace name"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 700,
                child: MonthView(),
              ),
              TextButton(
                onPressed: () {
                  CalendarControllerProvider.of(context).controller.add(event);
                },
                child: Text("asdfsd"),
              ),
              Text(MyLoremipsum.loremIpsum),
            ],
          ),
        ),
      ),
    );
  }
}
