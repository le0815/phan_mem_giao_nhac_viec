import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_drawer.dart';
import 'package:phan_mem_giao_nhac_viec/pages/body_task.dart';
import 'package:phan_mem_giao_nhac_viec/pages/body_home.dart';
import 'package:phan_mem_giao_nhac_viec/pages/body_message.dart';
import 'package:phan_mem_giao_nhac_viec/pages/body_workspace.dart';
import 'package:phan_mem_giao_nhac_viec/pages/user_page.dart';
import 'package:phan_mem_giao_nhac_viec/services/database/database_service.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> bodyComponents = [
    const BodyHome(),
    BodyTask(
      key: bodyTaskGlobalKey,
    ),
    const BodyMessage(),
    BodyWorkspace(),
  ];

  var appBarTitles = {
    0: const Text('Workspace Name'),
    1: const Text('My task'),
    2: const Text('Messages'),
    3: const Text('My workspace'),
  };
  int btmNavIdx = 0;
  refreshHomePage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // backgroundColor: const Color.fromARGB(217, 217, 217, 217),
        title: appBarTitles[btmNavIdx],
        actions: [
          // usr button
          Tooltip(
            triggerMode: TooltipTriggerMode.longPress,
            message: FirebaseAuth.instance.currentUser!.uid,
            child: GestureDetector(
              onTap: () async {
                // get user info
                var modelUser = await DatabaseService.instance
                    .getUserByUID(FirebaseAuth.instance.currentUser!.uid);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserPage(
                      modelUser: modelUser,
                    ),
                  ),
                );
              },
              child: Container(
                width: 30,
                height: 30,
                // padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(217, 217, 217, 217),
                    borderRadius: BorderRadius.circular(16)),
                child: const Center(child: Text("H")),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      drawer: const MyDrawer(),
      body: bodyComponents[btmNavIdx],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: btmNavIdx,
        onTap: (value) {
          setState(() {
            btmNavIdx = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: "Tasks",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox_outlined),
            label: "Message",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_2_outlined),
            label: "Workspace",
          ),
        ],
      ),
    );
  }
}
