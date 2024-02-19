import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:we_link/models/notification_body.dart';

class HttpHelper {
  static void sendNotificationTo({
    required String senderName,
    required String receiverToken,
    required String messageBody,
    required Map<String, dynamic> loginModel,
  }) async {
    Uri url = Uri.https('fcm.googleapis.com', '/fcm/send');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization':
          'key=AAAAqwAvkgA:APA91bG_JLZVB4g6mPE7i7dGmx-GD1tc6Qhf0qOk_klEMPlxgJB2gY9ziw66H2eohgDqKkvNt'
              '-nQGH9CbAw5hf2DQ5Kj-kiOR3VRhh_wSuloPfFZC8UOLG1bigdeb0Kn2vV0jZRaVUic'
    };

    final body = jsonEncode(
      notificationBody(
        senderName: senderName,
        receiverToken: receiverToken,
        messageBody: messageBody,
        model: loginModel,
      ),
      toEncodable: (nonEncodable) => notificationBody(
        senderName: senderName,
        receiverToken: receiverToken,
        messageBody: messageBody,
        model: loginModel,
      ),
    );
    await http.post(
      url,
      body: body,
      headers: headers,
    );
  }
}
