import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
              SizedBox(
                height: 50,
              ),
              ListTile(
                onTap: () => Navigator.pushNamed(context, "/body_home"),
                leading: Icon(Icons.home_outlined),
                title: Text("Home"),
              ),
              ListTile(
                onTap: () => Navigator.pushNamed(context, "/body_message"),
                leading: Icon(Icons.inbox_outlined),
                title: Text("Messages"),
              ),
              ListTile(
                leading: Icon(Icons.settings_sharp),
                title: Text("Settings"),
              ),
            ],
          ),
          ListTile(
            onTap: () => exit(0),
            leading: Icon(Icons.exit_to_app_outlined),
            title: Text("Exit"),
          ),
        ],
      ),
    );
  }
}
