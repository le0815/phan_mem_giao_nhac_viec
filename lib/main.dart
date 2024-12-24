import 'package:calendar_view/calendar_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phan_mem_giao_nhac_viec/constraint/constraint.dart';
import 'package:phan_mem_giao_nhac_viec/firebase_options.dart';
import 'package:phan_mem_giao_nhac_viec/local_database/hive_boxes.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_chat.dart';
import 'package:phan_mem_giao_nhac_viec/services/auth/auth_gate.dart';
import 'package:phan_mem_giao_nhac_viec/pages/body_task.dart';
import 'package:phan_mem_giao_nhac_viec/pages/body_home.dart';
import 'package:phan_mem_giao_nhac_viec/pages/body_message.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:phan_mem_giao_nhac_viec/services/database/database_service.dart';
import 'package:phan_mem_giao_nhac_viec/services/notification_service/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/data/latest.dart' as tz;

final navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
const taskName = "testTask";

testBackgroundTask() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await NotificationService.instance.initNotify();
  await NotificationService.instance.showNotify(
    id: 0,
    title: FirebaseAuth.instance.currentUser!.uid,
    body:
        "I've been a rich man, I've been a poor man. And I choose rich every fucking time!",
  );
}

void callbackDispatcher() {
  Workmanager().executeTask(
    (taskName, inputData) async {
      await testBackgroundTask();
      return Future.value(true);
    },
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // hive
  await Hive.initFlutter();
  HiveBoxes.instance.registerAllAdapters();

  await HiveBoxes.instance.openAllBoxes();
  HiveBoxes.instance.taskHiveBox.clear();

  // notification
  await NotificationService.instance.initNotify();

  // background service
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  tz.initializeTimeZones();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DatabaseService>(
            create: (context) => DatabaseService.instance),
      ],
      child: CalendarControllerProvider(
        controller: EventController(),
        child: MaterialApp(
          // key: navigatorKey,
          navigatorKey: navigatorKey,
          // scaffoldMessengerKey: scaffoldMessengerKey,
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
