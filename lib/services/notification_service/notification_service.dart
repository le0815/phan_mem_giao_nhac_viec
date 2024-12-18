import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as service_control;
import 'package:phan_mem_giao_nhac_viec/services/auth/auth_service.dart';
import 'package:phan_mem_giao_nhac_viec/ultis/ultis.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../models/model_user.dart';
import '../database/database_service.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._();
  final _firebaseMessaging = FirebaseMessaging.instance;
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationService._();

  Future requestPermission() async {
    await _firebaseMessaging.requestPermission(
      announcement: true,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestExactAlarmsPermission();

    var notifyPermission = await _firebaseMessaging.getNotificationSettings();

    // user must allow notification to use the app
    if (notifyPermission.authorizationStatus !=
        AuthorizationStatus.authorized) {
      await requestPermission();
    } else {
      return;
    }
  }

  @pragma('vm:entry-point')
  Future<void> initNotify() async {
    await requestPermission();

    final token = await _firebaseMessaging.getToken();

    log("FCM token: $token");
    FirebaseMessaging.onBackgroundMessage(handleBackgroundNotify);

    await initLocalNotify();

    // Listen for messages in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      return await handleForegroundNotify(message);
    });
  }

  Future initLocalNotify() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );
  }

  scheduleBackgroundNotify(DateTime time) async {
    log("start time utc: ${time.toUtc()}");
    log("tz time: ${tz.TZDateTime.from(time.toUtc(), tz.getLocation("Asia/Ho_Chi_Minh"))}");
    log("creating background notify");
    flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        "Task is start",
        "test task",
        tz.TZDateTime.from(time.toUtc(), tz.getLocation("Asia/Ho_Chi_Minh")),
        notificationDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.alarmClock);
  }

  notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "channelId", "channelName",
        importance: Importance.max,
        priority: Priority.high, // Ensure priority is set to high
        playSound: true,
      ),
    );
  }

  Future<void> showNotify(
      {required int id, String? title, String? body}) async {
    return await flutterLocalNotificationsPlugin.show(
        id, title, body, notificationDetails());
  }

  Future<void> handleForegroundNotify(RemoteMessage remoteMessage) async {
    if (remoteMessage.notification != null) {
      log("foreground notify at: ${DateTime.now()}");
      log("foreground notify title: ${remoteMessage.notification?.title}");
      log("foreground notify body: ${remoteMessage.notification?.body}");
      log("foreground notify payload: ${remoteMessage.data}");

      // Show the notification
      await showNotify(
        id: remoteMessage
            .hashCode, // You can use a unique ID for each notification
        title: remoteMessage.notification!.title,
        body: remoteMessage.notification!.body,
      );
    }
  }

  Future getAccessToken() async {
    var authorization =
        await readJsonFile("API_KEY/nckhflutter_bac6d88f6505.json");
    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];
    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(authorization),
      scopes,
    );

    // get access token
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(authorization),
      scopes,
      client,
    );

    client.close();
    return credentials.accessToken.data;
  }

  Future sendNotification(
      {required List receiverToken, String? title, String? body}) async {
    const String fcmApiUrl =
        "https://fcm.googleapis.com/v1/projects/nckhflutter/messages:send";

    String accessToken = await getAccessToken();
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    // send notification request to each fcmToken in receiverToken
    for (var element in receiverToken) {
      final Map<String, dynamic> message = {
        "message": {
          "token": element,
          "notification": {
            "title": title,
            "body": body,
          }
        },
      };

      try {
        final http.Response response = await http.post(
          Uri.parse(fcmApiUrl),
          headers: headers,
          body: jsonEncode(message),
        );

        if (response.statusCode == 200) {
          print('Notification sent successfully');
        } else {
          print('Failed to send notification: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } catch (e) {
        print('Error sending notification: $e');
      }
    }
  }

  Future removeFcmToken() async {
    // get current user info
    ModelUser modelUser = await DatabaseService()
        .getUserByUID(FirebaseAuth.instance.currentUser!.uid);

    // current fcm token
    var fcmToken = await _firebaseMessaging.getToken();
    // remove fcm token of device
    modelUser.fcm.removeWhere((element) => element == fcmToken);

    AuthService().updateUserInfoToDatabase(modelUser);
  }
}

@pragma('vm:entry-point')
Future<void> handleBackgroundNotify(RemoteMessage remoteMessage) async {
  if (remoteMessage.notification != null) {
    log("notify title: ${remoteMessage.notification?.title}");
    log("notify body: ${remoteMessage.notification?.body}");
    log("notify payload: ${remoteMessage.data}");
  }
}
