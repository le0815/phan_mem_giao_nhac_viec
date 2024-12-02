import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                onTap: () => Navigator.pushNamed(context, "/body_home"),
                leading: const Icon(Icons.home_outlined),
                title: const Text("Home"),
              ),
              ListTile(
                onTap: () => Navigator.pushNamed(context, "/body_message"),
                leading: const Icon(Icons.inbox_outlined),
                title: const Text("Messages"),
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
