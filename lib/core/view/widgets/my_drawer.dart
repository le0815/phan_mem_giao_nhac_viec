import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phan_mem_giao_nhac_viec/features/auth/view_model/auth_view_model.dart';
import 'package:phan_mem_giao_nhac_viec/features/setting/view/pages/setting_page.dart';

import '../../../main.dart';

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
                  var homePageSate = appUIGlobalKey.currentState!;
                  homePageSate.btmNavIdx = 0;
                  homePageSate.refreshHomePage();
                  Navigator.pop(context); // Close the drawer
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const HomePage()),
                  // );
                },
                leading: const Icon(Icons.home_outlined),
                title: Text(
                  AppLocalizations.of(context)!.home,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              ListTile(
                onTap: () {
                  var homePageSate = appUIGlobalKey.currentState!;
                  homePageSate.btmNavIdx = 1;
                  homePageSate.refreshHomePage();
                  Navigator.pop(context); // Close the drawer
                },
                leading: const Icon(Icons.add_box_outlined),
                title: Text(
                  AppLocalizations.of(context)!.tasks,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              ListTile(
                onTap: () {
                  var homePageSate = appUIGlobalKey.currentState!;
                  homePageSate.btmNavIdx = 2;
                  homePageSate.refreshHomePage();
                  Navigator.pop(context); // Close the drawer
                },
                leading: const Icon(Icons.message_outlined),
                title: Text(
                  AppLocalizations.of(context)!.message,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              ListTile(
                onTap: () {
                  var homePageSate = appUIGlobalKey.currentState!;
                  homePageSate.btmNavIdx = 3;
                  homePageSate.refreshHomePage();
                  Navigator.pop(context); // Close the drawer
                },
                leading: const Icon(Icons.groups_2_outlined),
                title: Text(
                  AppLocalizations.of(context)!.workspace,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingPage()),
                  );
                },
                leading: Icon(Icons.settings_sharp),
                title: Text(
                  AppLocalizations.of(context)!.settings,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          ListTile(
            onTap: () async {
              await AuthViewModel.instance.signOut();
            },
            leading: const Icon(Icons.exit_to_app_outlined),
            title: Text(
              AppLocalizations.of(context)!.exit,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
