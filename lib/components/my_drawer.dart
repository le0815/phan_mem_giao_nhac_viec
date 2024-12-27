import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/pages/body_message.dart';
import 'package:phan_mem_giao_nhac_viec/pages/body_task.dart';
import 'package:phan_mem_giao_nhac_viec/pages/home_page.dart';
import 'package:phan_mem_giao_nhac_viec/services/auth/auth_service.dart';

import '../main.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              ListTile(
                onTap: () {
                  var homePageSate = homePageGlobalKey.currentState!;
                  homePageSate.btmNavIdx = 0;
                  homePageSate.refreshHomePage();
                  Navigator.pop(context); // Close the drawer
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const HomePage()),
                  // );
                },
                leading: const Icon(Icons.home_outlined),
                title: const Text("Home"),
              ),
              ListTile(
                onTap: () {
                  var homePageSate = homePageGlobalKey.currentState!;
                  homePageSate.btmNavIdx = 1;
                  homePageSate.refreshHomePage();
                  Navigator.pop(context); // Close the drawer
                },
                leading: const Icon(Icons.add_box_outlined),
                title: const Text("Task"),
              ),
              ListTile(
                onTap: () {
                  var homePageSate = homePageGlobalKey.currentState!;
                  homePageSate.btmNavIdx = 2;
                  homePageSate.refreshHomePage();
                  Navigator.pop(context); // Close the drawer
                },
                leading: const Icon(Icons.message_outlined),
                title: const Text("Messages"),
              ),
              ListTile(
                onTap: () {
                  var homePageSate = homePageGlobalKey.currentState!;
                  homePageSate.btmNavIdx = 3;
                  homePageSate.refreshHomePage();
                  Navigator.pop(context); // Close the drawer
                },
                leading: const Icon(Icons.groups_2_outlined),
                title: const Text("Workspace"),
              ),
              const ListTile(
                leading: Icon(Icons.settings_sharp),
                title: Text("Settings"),
              ),
            ],
          ),
          ListTile(
            onTap: () async {
              var authService = AuthService();
              await authService.SignOut();
            },
            leading: const Icon(Icons.exit_to_app_outlined),
            title: const Text("Exit"),
          ),
        ],
      ),
    );
  }
}
