import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:phan_mem_giao_nhac_viec/local_database/hive_boxes.dart';
import 'package:phan_mem_giao_nhac_viec/models/model_task.dart';
import 'package:phan_mem_giao_nhac_viec/services/auth/auth_service.dart';
import 'package:phan_mem_giao_nhac_viec/services/background_service/background_service.dart';
import 'package:phan_mem_giao_nhac_viec/ultis/ultis.dart';
import 'package:uuid/uuid.dart';
import 'package:workmanager/workmanager.dart';

import '../../constraint/constraint.dart';
import '../../models/model_user.dart';
import '../database/database_service.dart';
import '../task/task_service.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._();
  final AwesomeNotifications _awesomeNotifications = AwesomeNotifications();
  final _randomIDNotification = math.Random();
  final _localTimeZone = "Asia/Ho_Chi_Minh";
  NotificationService._();

  requestPermission() async {
    await _awesomeNotifications.isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed) {
          await _awesomeNotifications.requestPermissionToSendNotifications();
        }
      },
    );
  }

  notificationEvents() async {
    await _awesomeNotifications.setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onNotificationDisplayedMethod: onNotificationDisplayedMethod);
  }

  initialize() async {
    await localNotificationInit();
    await requestPermission();
    // _awesomeNotificationsFcm.initialize(
    //   onFcmTokenHandle: myFcmTokenHandle,
    //   onFcmSilentDataHandle: mySilentDataHandle,
    // );
    await notificationEvents();

    log("fcm token: ${await FirebaseMessaging.instance.getToken()}");
  }

  Future<void> localNotificationInit() async {
    await _awesomeNotifications.initialize(
      // set the icon to null if you want to use the default app icon
      'resource://drawable/ic_launcher',
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          enableLights: true,
          enableVibration: true,
        )
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true,
    );
  }

  @pragma("vm:entry-point")
  static Future<void> mySilentDataHandle(FcmSilentData silentData) async {
    log('"SilentData": ${silentData.toString()}');

    if (silentData.createdLifeCycle != NotificationLifeCycle.Foreground) {
      log("BACKGROUND");
    } else {
      log("FOREGROUND");
    }
  }

  createNotification(
      {required String title,
      required String body,
      required Map<String, String> payload}) async {
    await _awesomeNotifications.createNotification(
        content: NotificationContent(
      id: _randomIDNotification.nextInt(999),
      channelKey: 'basic_channel',
      actionType: ActionType.Default,
      title: title,
      body: body,
      payload: payload,
    ));
  }

  createScheduleNotification(
      {required String title,
      String? body,
      required Map<String, String> payload,
      required DateTime time}) async {
    log("creating schedule alarm for task in: $time");
    await _awesomeNotifications.createNotification(
      content: NotificationContent(
        id: _randomIDNotification.nextInt(999),
        channelKey: 'basic_channel',
        title: title,
        body: body,
        payload: payload,
        category: NotificationCategory.Alarm,
      ),
      schedule: NotificationCalendar(
        second: 0,
        minute: time.minute,
        hour: time.hour,
        day: time.day,
        month: time.month,
        year: time.year,
        timeZone: _localTimeZone,
        repeats: false,
        allowWhileIdle: true,
      ),
    );
  }

  Future<List<NotificationModel>> getScheduleNotification() async {
    return await _awesomeNotifications.listScheduledNotifications();
  }

  clearAllScheduleAlarm() async {
    await _awesomeNotifications.cancelAllSchedules();
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
      {required List receiverToken,
      String? title,
      String? body,
      Map? payload}) async {
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
          },
          "data": payload,
        },
      };

      try {
        final http.Response response = await http.post(
          Uri.parse(fcmApiUrl),
          headers: headers,
          body: jsonEncode(message),
        );

        if (response.statusCode == 200) {
          log('Notification sent successfully');
        } else {
          log('Failed to send notification: ${response.statusCode}');
          log('Response body: ${response.body}');
        }
      } catch (e) {
        log('Error sending notification: $e');
      }
    }
  }

  Future removeFcmToken() async {
    // get current user info
    ModelUser modelUser = await DatabaseService.instance
        .getUserByUID(FirebaseAuth.instance.currentUser!.uid);

    // current fcm token
    var fcmToken = await FirebaseMessaging.instance.getToken();
    // remove fcm token of device
    modelUser.fcm.removeWhere((element) => element == fcmToken);

    AuthService().updateUserInfoToDatabase(modelUser);
  }

  static appAliveNotificationHandle(Map<String, dynamic> notificationData) {
    log("handling notification data in alive mode");
    Map? payload = notificationData["payload"];
    if (payload != null && payload.isNotEmpty) {
      // sync data
      if (payload["syncType"] != null) {
        payload.forEach(
          (key, value) {
            HiveBoxes.instance.syncData(syncType: value);
          },
        );
        // set schedule alarm for task
        BackgroundService.instance.setScheduleAlarm();
      }

      // if notification is schedule alarm
      if (payload["notificationType"] != null) {
        // decode string to map cause payload["modelTask"] is String datatype
        var decodedModelTask = json.decode(payload["modelTask"]);
        ModelTask modelTask = ModelTask.fromMap(decodedModelTask);
        // update task state
        var idTask = payload["idTask"];
        modelTask.state = payload["taskState"];
        HiveBoxes.instance.taskHiveBox.put(idTask, modelTask.ToMap());
        // update task to database
        TaskService.instance.UpdateTaskToDb(idTask, modelTask);
      }
    }
  }

  @pragma("vm:entry-point")
  static terminatedNotificationHandle(Map<String, dynamic> notificationData) {
    log("handling notification data in terminated mode");
    Map? payload = notificationData["payload"];
    if (payload != null && payload.isNotEmpty) {
      // use workmanager to sync data
      Workmanager().registerOneOffTask(
        const Uuid().v1().toString(),
        BackgroundTaskName.syncHiveData,
        inputData: {"syncType": payload},
      );
    }
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    Map<String, dynamic> notificationData = {
      "appStatus": receivedNotification.displayedLifeCycle!.name,
      "title": receivedNotification.title,
      "body": receivedNotification.body,
      "payload": receivedNotification.payload,
    };
    // depends on app status (back or foreground) to handle the notification
    if (receivedNotification.displayedLifeCycle ==
        NotificationLifeCycle.Terminated) {
      terminatedNotificationHandle(notificationData);
    } else {
      appAliveNotificationHandle(notificationData);
    }

    log("notification received: $notificationData");
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    log("onActionReceivedMethod: ${receivedAction.title}");
    log("onActionReceivedMethod: ${receivedAction.body}");
    log("onActionReceivedMethod: ${receivedAction.payload}");
  }
}
