import 'dart:developer';

import 'package:calendar_view/calendar_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_alert_dialog.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_snackbar.dart';
import 'package:phan_mem_giao_nhac_viec/pages/chat_box_page.dart';
import 'package:phan_mem_giao_nhac_viec/services/auth/auth_gate.dart';
import 'package:phan_mem_giao_nhac_viec/pages/body_task.dart';
import 'package:phan_mem_giao_nhac_viec/pages/body_home.dart';
import 'package:phan_mem_giao_nhac_viec/pages/body_message.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:phan_mem_giao_nhac_viec/services/database/database_service.dart';
import 'package:phan_mem_giao_nhac_viec/services/firebase_messaging/firebase_messaging_service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessagingService.instance.initNotify();

  // FirebaseMessaging.onMessage.listen(
  //   (RemoteMessage message) {
  //     log("foreground notifi");
  //     if (message.notification != null) {
  //       scaffoldMessengerKey.currentState?.showSnackBar(
  //         SnackBar(
  //           content: Text(message.notification!.body!),
  //           action: SnackBarAction(
  //             label: "Snack bar action",
  //             onPressed: () {
  //               navigatorKey.currentState!.pushNamed("/body_task");
  //             },
  //           ),
  //         ),
  //       );
  //     }
  //   },
  // );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DatabaseService>(
            create: (context) => DatabaseService()),
      ],
      child: CalendarControllerProvider(
        controller: EventController(),
        child: MaterialApp(
          // key: navigatorKey,
          navigatorKey: navigatorKey,
          scaffoldMessengerKey: scaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          // theme: ThemeData(
          //     scaffoldBackgroundColor: const Color.fromARGB(217, 217, 217, 217),
          //     colorScheme: ColorScheme.light(
          //       // primary: Colors.white,
          //       surface: Colors.white,
          //     )),
          home: const AuthPage(),
          //route for navigation page
          routes: {
            "/body_home": (context) => const BodyHome(),
            "/body_task": (context) => const BodyTask(),
            "/body_message": (context) => const BodyMessage(),
          },
        ),
      ),
    );
  }
}
