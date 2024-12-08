import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/pages/body_message.dart';
import 'package:phan_mem_giao_nhac_viec/pages/body_task.dart';
import 'package:phan_mem_giao_nhac_viec/pages/home_page.dart';
import 'package:phan_mem_giao_nhac_viec/services/auth/auth_service.dart';

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
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                leading: const Icon(Icons.home_outlined),
                title: const Text("Home"),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BodyTask()),
                  );
                },
                leading: const Icon(Icons.add_box_outlined),
                title: const Text("Task"),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BodyMessage()),
                  );
                },
                leading: const Icon(Icons.message_outlined),
                title: const Text("Messages"),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                leading: const Icon(Icons.groups_2_outlined),
                title: const Text("Group"),
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
