import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:we_link/shared/styles/colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RemoteMessage? message =
        ModalRoute.of(context)!.settings.arguments as RemoteMessage?;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(message?.notification?.title.toString() ?? '',),
            Text(message?.notification?.body.toString() ?? '',),
          ],
        ),
      ),
    );
  }
}
