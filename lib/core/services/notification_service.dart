import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:phan_mem_giao_nhac_viec/core/view/pages/app_ui.dart';
import 'package:phan_mem_giao_nhac_viec/features/message/view/pages/message_page.dart';
import 'package:phan_mem_giao_nhac_viec/main.dart';
import 'package:uuid/uuid.dart';
import 'package:workmanager/workmanager.dart';

import 'package:phan_mem_giao_nhac_viec/core/repositories/local_repo.dart';
import 'package:phan_mem_giao_nhac_viec/core/services/background_service.dart';
import 'package:phan_mem_giao_nhac_viec/core/ultis/ultis.dart';

import '../constraint/constraint.dart';

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
          await _awesomeNotifications.requestPermissionToSendNotifications(
            permissions: const [
              NotificationPermission.Alert,
              NotificationPermission.Sound,
              NotificationPermission.Badge,
              NotificationPermission.Vibration,
              NotificationPermission.Light,
              NotificationPermission.PreciseAlarms,
            ],
          );
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
        category: NotificationCategory.Reminder,
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
          // body: message,
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

  static appAliveNotificationHandle(Map<String, dynamic> notificationData) {
    log("handling notification data in alive mode");
    Map? payload = notificationData["payload"];
    if (payload != null && payload.isNotEmpty) {
      // form of the payload
      // {
      //   "notificationType": 'schedule' or 'remote'
      //   "0": syncTask1,
      //   "1": syncTask2,
      // }

      // handle notification
      if (payload["notificationType"] != null) {
        // if is local schedule notification
        if (payload["notificationType"] == "schedule") {
          BackgroundService.instance.updateTaskState(payload);
        }
        // if is remote notification
        if (payload["notificationType"] == "remote") {
          payload.forEach(
            (key, value) {
              // skip if value of payload id notification type
              if (key == "notificationType") {
                return;
              }
              // sync data
              LocalRepo.instance.syncData(syncType: value);
              // if sync type is syncTask -> update schedule notification
              if (value == SyncTypes.syncTask) {
                BackgroundService.instance.setScheduleAlarm();
              }
            },
          );
        }
      }
    }
  }

  @pragma("vm:entry-point")
  static terminatedNotificationHandle(Map<String, dynamic> notificationData) {
    log("handling notification data in terminated mode");
    Map? payload = notificationData["payload"];
    if (payload != null && payload.isNotEmpty) {
      // form of the payload
      // {
      //   "notificationType": 'schedule' or 'remote'
      //   "0": syncTask1,
      //   "1": syncTask2,
      // }

      // handle notification
      if (payload["notificationType"] != null) {
        // if is local schedule notification
        if (payload["notificationType"] == "schedule") {
          // use workmanager to sync data
          Workmanager().registerOneOffTask(
            const Uuid().v1().toString(),
            BackgroundTaskName.syncHiveData,
            inputData: {"syncType": SyncTypes.syncTask},
          );
        }
        // if is remote notification
        if (payload["notificationType"] == "remote") {
          payload.forEach(
            (key, value) {
              // skip if value of payload id notification type
              if (key == "notificationType") {
                return;
              }
              // use workmanager to sync data
              Workmanager().registerOneOffTask(
                const Uuid().v1().toString(),
                BackgroundTaskName.syncHiveData,
                inputData: {"syncType": payload},
              );
            },
          );
        }
      }
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
    Map? payload = receivedAction.payload;
    // handle notification
    if (payload?["notificationType"] != null) {
      // redirect to certain page when user tapped
      // the 'pageIndex' can be find in appUI.dart
      Route createRoute(Widget destinationPage) {
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              destinationPage,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end);
            final offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      }

      // if is local schedule notification
      if (payload!["notificationType"] == "schedule") {
        navigatorKey.currentState!.push(
          (createRoute(
            const AppUi(
              pageIndex: 1,
            ),
          )),
        );
      }
      // if is remote notification
      if (payload["notificationType"] == "remote") {
        payload.forEach(
          (key, value) {
            // skip if value of payload id notification type
            if (key == "notificationType") {
              return;
            }
            // if sync type is syncTask -> update schedule notification
            if (value == SyncTypes.syncMessage) {
              navigatorKey.currentState!.push(
                (createRoute(
                  const AppUi(
                    pageIndex: 2,
                  ),
                )),
              );
            }
            if (value == SyncTypes.syncTask) {
              navigatorKey.currentState!.push(
                (createRoute(
                  const AppUi(
                    pageIndex: 1,
                  ),
                )),
              );
            }
            if (value == SyncTypes.syncWorkSpace) {
              navigatorKey.currentState!.push(
                (createRoute(
                  const AppUi(
                    pageIndex: 3,
                  ),
                )),
              );
            }
          },
        );
      }
    }
  }
}
