import 'dart:developer';
import 'dart:ui';

import 'package:calendar_view/calendar_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phan_mem_giao_nhac_viec/features/auth/view_model/auth_gate_view_model.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:workmanager/workmanager.dart';

import 'package:phan_mem_giao_nhac_viec/constraint/constraint.dart';
import 'package:phan_mem_giao_nhac_viec/firebase_options.dart';
import 'package:phan_mem_giao_nhac_viec/local_database/hive_boxes.dart';
import 'package:phan_mem_giao_nhac_viec/pages/body_home.dart';
import 'package:phan_mem_giao_nhac_viec/pages/body_message.dart';
import 'package:phan_mem_giao_nhac_viec/pages/body_task.dart';
import 'package:phan_mem_giao_nhac_viec/services/background_service/background_service.dart';
import 'package:phan_mem_giao_nhac_viec/services/database/database_service.dart';
import 'package:phan_mem_giao_nhac_viec/services/language_service/language_service.dart';
import 'package:phan_mem_giao_nhac_viec/services/notification_service/notification_service.dart';

import 'core/theme/theme_config.dart';
import 'pages/home_page.dart';
import 'services/network_state_service/network_state_service.dart';

final bodyTaskGlobalKey = GlobalKey<BodyTaskState>();
final homePageGlobalKey = GlobalKey<HomePageState>();
final navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask(
    (taskName, inputData) async {
      try {
        log("Initializing Hive in background task");
        await Hive.initFlutter();
        log("Hive initialized");
        HiveBoxes.instance.registerAllAdapters();
        log("Adapters registered");
        await HiveBoxes.instance.openAllBoxes();
        log("Hive boxes opened");
        log("hive box task data: ${HiveBoxes.instance.taskHiveBox}");
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        log("Firebase initialized");

        if (BackgroundTaskName.syncHiveData == taskName) {
          Map inputDataMap = inputData!["syncType"] as Map;

          inputDataMap.forEach(
            (key, value) async {
              await BackgroundService.instance.syncData(value);
              // if sync task -> update notification
              if (value == SyncTypes.syncTask) {
                BackgroundService.instance.setScheduleAlarm();
              }
            },
          );
        }
        // if (BackgroundTaskName.sendDataFromIsolate == taskName) {
        //   BackgroundService.sendDataToMainIsolate(inputData!["portName"]);
        //   // sendDataToMainIsolate(inputData!["portName"]);
        // }

        log("Background task completed");

        return Future.value(true);
      } catch (e) {
        log("Error in background task: $e");
        return Future.value(false);
      }
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
  // sync hive data if user logged in
  if (FirebaseAuth.instance.currentUser != null) {
    HiveBoxes.instance.syncAllData();
  }

  // notification
  await NotificationService.instance.initialize();

  // background service
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  tz.initializeTimeZones();

  runApp(const MyApp());

  // check the connection state
  NetworkStateService();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DatabaseService>(
            create: (context) => DatabaseService.instance),
        ChangeNotifierProvider<LanguageService>(
            create: (context) => LanguageService.instance),
      ],
      child: CalendarControllerProvider(
        controller: EventController(),
        child: ChangeNotifierProvider(
          create: (context) => LanguageService.instance,
          child: Consumer<LanguageService>(
            builder: (context, value, child) {
              int? currentLanguagePreference =
                  HiveBoxes.instance.userSettingHiveBox.toMap()["language"] ??
                      0;
              return MaterialApp(
                // key: navigatorKey,
                navigatorKey: navigatorKey,
                scaffoldMessengerKey: scaffoldMessengerKey,
                debugShowCheckedModeBanner: false,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: currentLanguagePreference == 0
                    ? const Locale("en")
                    : const Locale("vi"),
                theme: ThemeConfig.lightTheme,
                home: const AuthGateViewModel(),
                //route for navigation page
                routes: {
                  "/body_home": (context) => const BodyHome(),
                  "/body_task": (context) => const BodyTask(),
                  "/body_message": (context) => const BodyMessage(),
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
