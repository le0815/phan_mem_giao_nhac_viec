import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:phan_mem_giao_nhac_viec/components/my_drawer.dart';
import 'package:phan_mem_giao_nhac_viec/core/repositories/local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/core/view/widgets/my_bottom_app_bar.dart';
import 'package:phan_mem_giao_nhac_viec/core/widgets/add_space.dart';
import 'package:phan_mem_giao_nhac_viec/features/home/view/pages/home_page.dart';
import 'package:phan_mem_giao_nhac_viec/features/message/view/pages/message_page.dart';
import 'package:phan_mem_giao_nhac_viec/features/task/view/pages/task_page.dart';
import 'package:phan_mem_giao_nhac_viec/features/workspace/view/pages/workspace_page.dart';
import 'package:phan_mem_giao_nhac_viec/main.dart';

class AppUi extends StatefulWidget {
  const AppUi({super.key});

  @override
  State<AppUi> createState() => AppUiState();
}

class AppUiState extends State<AppUi> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> bodyComponents = [
    const HomePage(),
    TaskPage(
      key: taskPageGlobalKey,
    ),
    const MessagePage(),
    WorkspacePage(),
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

  Future _refresh() async {
    try {
      await LocalRepo.instance.syncAllData();
    } catch (e) {
      log("error while sync data: $e");
    }
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
          // const UserAppbarButton(),
          AddHorizontalSpace(10)
        ],
      ),
      drawer: const MyDrawer(),
      // use stack cause RefreshIndicator only works with ListView by design
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Stack(
          children: [
            ListView(),
            bodyComponents[btmNavIdx],
          ],
        ),
      ),
      bottomNavigationBar: MyBottomAppBar(
        onTap: (value) {
          log("selected nav: $value");
          setState(() {
            btmNavIdx = value;
          });
        },
        selectedIndex: btmNavIdx,
        items: const [
          ImageIcon(AssetImage("assets/icons/home.png")),
          ImageIcon(AssetImage("assets/icons/task.png")),
          ImageIcon(AssetImage("assets/icons/message.png")),
          ImageIcon(AssetImage("assets/icons/workspace.png")),
        ],
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // type: BottomNavigationBarType.fixed,
      currentIndex: 1,
      onTap: (value) {},
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_filled),
          label: AppLocalizations.of(context)!.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.add_box_outlined),
          label: AppLocalizations.of(context)!.tasks,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.inbox_outlined),
          label: AppLocalizations.of(context)!.message,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.groups_2_outlined),
          label: AppLocalizations.of(context)!.workspace,
        ),
      ],
    );
  }
}
