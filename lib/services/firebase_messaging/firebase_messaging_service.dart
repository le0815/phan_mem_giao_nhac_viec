import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as service_control;
import 'package:phan_mem_giao_nhac_viec/ultis/read_json_file.dart';

class FirebaseMessagingService {
  static final FirebaseMessagingService instance = FirebaseMessagingService._();
  final _firebaseMessaging = FirebaseMessaging.instance;
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  FirebaseMessagingService._();

  Future requestPermission() async {
    await _firebaseMessaging.requestPermission(
      announcement: true,
    );
  }

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
    // var authorization = {
    //   "type": "service_account",
    //   "project_id": "nckhflutter",
    //   "private_key_id": "bac6d88f65053ec21f91cc5b0c467935140d7255",
    //   "private_key":
    //       "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCbkkcIFrbFGx86\n1OrOkDvPUuzTGhnEJ5LWiMjIKiP9kQPaeekynFCPSDwFT+7hIZkJJxvtm2fcAfTP\npDnWaIhCTx6pgWAxBGWTLIUUhRWNdtLB9Z13PhZ5W7PHvOPDl5uWRDTUh6nxvzto\naGqGkSJvNpYv/0g0475gaOPbiwbc/KThVmy5j2kI8BwstqOudRpenDfoUcqT94w3\n7MgVoWhjNx2DRJ7NhMod9tYV4PtcAAjUh+0iTV0idLXIRKAvsBFFg/xgVVpdKFW1\nG3f7bYycEDPcUaXLghLPiyWUz/Y19xCPE0iLIa2Dk0pGdCw/xZ6JJYI8hfOEnVwt\no89EdpYnAgMBAAECggEAQ+vgcUqhb3sA7ompHphgVIsq9JvPphF1DY9YwfOMFRfs\nK8XQJ5WRoozyD4uvisFFdHaLvfh8ptR/0uwriE3JN9IdW/otShlWU6Q7UhMsrr+z\nEpWuszH7U+7SliEE/A9EEZ4jxqqYawCH6nS0FZ5l/1JAziHRn63TH3qMCP0w+Ofy\nDYAidD9ijOx6EcviAsoYU5N+Y75kOnbvsYl0KAcFAwbeDbLY/sMe9NGcr0e6BMyT\nScXJt7vkhlmhReEEmEcJlZjBiAx6p+W/JyF4LzpYIDytfsgQdbKg4MjY4UiC3CGK\ngjLsvJEK/4va18xiWZic5YiXo1ApKuAr/lysT4/EGQKBgQDaICGF6kFZX2E7Pxoe\nS4LDlFV516QJzgFqphqhkowPq3oGwlXu2j8kmBEVlft9PJFANUeHVVS8eEjVu+TY\nWnIrer4aZIbZ+DiKu9L1dgLFMFhJdsaxrrV2i9pT8GZi5pewu2s2wv6kVRnTeXdZ\nOf8qHVLuJC+IhMskAm59R58/cwKBgQC2lY/EfqPvpbOkT1b4C4ZUfBlmQeFQkgpn\nUOjDH+nYkdcdbEt4YlIqecmAd43fSEU5YwB8J43OqLPj/Ul0IZ3UEkYzABMC36r0\nT1a0tR4ghMD7Nn6axSLM7GEqvDCis7ouM0BLQwH7DIo1lts31ltGQywL+f2/wz8/\nneldAhw5fQKBgHQvASwvZreQEl5YcjUIy5IZhJ3turZuQFrqNu0w/eGq2MiY4uTi\n4xc+2HrC9L30cPneZ0cysHvjJgiSmIaVRpLaQkAUo6+eg5+CBBAy167o3V3kIlmq\nUYXfYF+tgRvU7593dNgqbTBjE+qMnIGuXrez/uRR6e+xq/J2SRv59lz5AoGBAIOv\nPOCIQe5ewUC5ZE1D6p9WXe9NhpbYrZ40UZwhkUP8c3yqFYh+ySoPalA4ad9nPV4V\nVE03LeSl8hB2JpsWf8FraKvx2sRQ0vifnDZ7Bn6HoLPOauNvWRkZRz9OOXmvTJFz\nr2RYsL4DHk9mPTd5Z502ZzdAF05OIHjeiGfnVLn1AoGBANJgosS4ng3xKgdK+1mP\n9jk+9np1uK8c6SKcWjUiqOD2Nx9Ir/HIL+F3zqj8HGnWpm9Q7AvSfpJ/+rMu3qwJ\nsR7RyyU4/xfEki+GoKm49/C9l4hbMpbkHtYWGoJu2TGFj02MDcbylUK6Uy9DFK6L\np8ZUDSJeOWthtIB6bSe6b5OZ\n-----END PRIVATE KEY-----\n",
    //   "client_email":
    //       "firebase-adminsdk-qc3jn@nckhflutter.iam.gserviceaccount.com",
    //   "client_id": "102475691110263764327",
    //   "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    //   "token_uri": "https://oauth2.googleapis.com/token",
    //   "auth_provider_x509_cert_url":
    //       "https://www.googleapis.com/oauth2/v1/certs",
    //   "client_x509_cert_url":
    //       "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-qc3jn%40nckhflutter.iam.gserviceaccount.com",
    //   "universe_domain": "googleapis.com"
    // };
    var authorization = await readJsonFile(
        "/home/ha/Desktop/Flutter/phan_mem_giao_nhac_viec/API_KEY/nckhflutter_bac6d88f6505.json");
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
      {required String receiverToken, String? title, String? body}) async {
    const String fcmApiUrl =
        "https://fcm.googleapis.com/v1/projects/nckhflutter/messages:send";

    String accessToken = await getAccessToken();

    final Map<String, dynamic> message = {
      "message": {
        "token": receiverToken,
        "notification": {
          "title": title,
          "body": body,
        }
      },
    };

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
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

@pragma('vm:entry-point')
Future<void> handleBackgroundNotify(RemoteMessage remoteMessage) async {
  if (remoteMessage.notification != null) {
    log("notify title: ${remoteMessage.notification?.title}");
    log("notify body: ${remoteMessage.notification?.body}");
    log("notify payload: ${remoteMessage.data}");
  }
}
