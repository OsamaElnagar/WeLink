import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:we_link/main.dart';
import 'package:we_link/shared/components/components.dart';
import 'package:http/http.dart' as http;

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission(provisional: true);

    final fcmToken = await FirebaseMessaging.instance.getToken();

    pint('fcmToken: $fcmToken');
    await initPushNotification();
    backgroundMessage();
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) {
      return;
    }
    navigatorKey.currentState?.pushNamed(
      '/notification_screen',
      arguments: message,
    );
  }

  Future initPushNotification() async {
    _firebaseMessaging.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

   backgroundMessage()  {
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  }

  Future<void> backgroundMessageHandler(RemoteMessage? message) async {
    // Handle the background message here
    if (message == null) {
      return;
    }
    navigatorKey.currentState?.pushNamed(
      '/notification_screen',
      arguments: message,
    );

    pint("Handling background message: ${message.messageId}");
  }

  Future sendMessageNotification({
    required String toUser,
    required String fromUser,
    required String messageBody,
  }) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverToken',
    };
    var body = {
      "to": toUser,
      "notification": {
        "title": fromUser,
        "body": messageBody,
        "sound": "default"
      },
      "android": {
        "priority": "HIGH",
        "notification": {
          "notification_priority": "PRIORITY_MAX",
          "sound": "default",
          "default_sound": "true",
          "default_vibrate_timings": "true",
          "default_light_settings": "true"
        }
      },
      "data": {
        "type": "order",
        "id": "1",
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
      }
    };
    var request =
        http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode(body);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      pint(await response.stream.bytesToString());
      log('message sent to server ( log )');
    } else {
      pint(response.reasonPhrase);
    }
  }

  static const String serverToken =
      "AAAAqwAvkgA:APA91bG_JLZVB4g6mPE7i7dGmx-GD1tc6Qhf0qOk_klEMPlxgJB2gY9ziw66H2eohgDqKkvNt-nQGH9CbAw5hf2DQ5Kj-kiOR3VRhh_wSuloPfFZC8UOLG1bigdeb0Kn2vV0jZRaVUic";
}
