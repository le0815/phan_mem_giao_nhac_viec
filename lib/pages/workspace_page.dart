import 'dart:developer';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_loading_indicator.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_user_tile_overview.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_user.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_workspace.dart';
import 'package:phan_mem_giao_nhac_viec/services/database/database_service.dart';

class WorkspacePage extends StatefulWidget {
  final ModelWorkspace modelWorkspace;
  // final String workspaceUID;
  const WorkspacePage({
    super.key,
    required this.modelWorkspace,
    // required this.workspaceUID,
  });

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  final event = CalendarEventData(
    date: DateTime.now(),
    title: "Project meeting",
    description: "Today is project meeting.",
    startTime: DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 18, 30),
    endTime: DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 22),
  );
  final databaseService = DatabaseService();

  Future<List> getUsers() async {
    final List<ModelUser> userList = [];
    for (var element in widget.modelWorkspace.members) {
      var result = await databaseService.getUserByUID(element);
      userList.add(result);
    }
    return userList;
  }

  @override
  Widget build(BuildContext context) {
    var dropdownValue = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text("Workspace name"),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.add), // Icon for the button
            onSelected: (value) {
              // Handle selected value
              log('You selected: $value');
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Text('Add member'),
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // show workspace task overview
            SizedBox(
              height: 500,
              child: MonthView(),
            ),
            // show members of workspace
            Container(
              height: 500,
              padding:
                  const EdgeInsets.only(top: 8, left: 12, right: 12, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text("Members",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(
                    thickness: 1,
                    color: Colors.black,
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: getUsers(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const MyLoadingIndicator();
                        }
                        if (!snapshot.hasData) {
                          return const Text("No member");
                        }

                        var result = snapshot.data;
                        log(result.toString());
                        return ListView.builder(
                          itemCount: result!.length,
                          itemBuilder: (context, index) {
                            return MyUserTileOverview(
                              userName: result[index].userName,
                              msg: result[index].email,
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
