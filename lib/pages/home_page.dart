import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_drawer.dart';
import 'package:phan_mem_giao_nhac_viec/pages/body_task.dart';
import 'package:phan_mem_giao_nhac_viec/pages/body_home.dart';
import 'package:phan_mem_giao_nhac_viec/pages/body_message.dart';
import 'dart:developer';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> bodyComponents = [
    const BodyHome(),
    const BodyTask(),
    const BodyMessage()
  ];

  var appBarTitles = {
    0: const Text('Workspace Name'),
    1: const Text('My task'),
    2: const Text('Messages')
  };
  int btmNavIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: const Color.fromARGB(217, 217, 217, 217),
        title: appBarTitles[btmNavIdx],
        actions: [
          // usr button
          Tooltip(
            triggerMode: TooltipTriggerMode.longPress,
            message: 'This is a descriptive tooltip for the button',
            child: GestureDetector(
              child: Container(
                width: 30,
                height: 30,
                // padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(217, 217, 217, 217),
                    borderRadius: BorderRadius.circular(16)),
                child: Center(child: Text("H")),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      drawer: MyDrawer(),
      body: bodyComponents[btmNavIdx],
      bottomNavigationBar: BottomNavigationBar(
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
        ],
      ),
    );
  }
}
