// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:rxdart/subjects.dart';
// import 'package:timezone/timezone.dart' as tz;
//
// import '../remote/download_helper.dart';
//
// class NotificationApi {
//   static final notifications = FlutterLocalNotificationsPlugin();
//   static final onNotifications = BehaviorSubject<String>();
//
//   static Future init({bool initScheduled = false}) async {
//     const iOS = IOSInitializationSettings();
//     const android = AndroidInitializationSettings("@mipmap/ic_launcher");
//     const settings = InitializationSettings(
//       android: android,
//       iOS: iOS,
//     );
//
//     final details = await notifications.getNotificationAppLaunchDetails();
//     if (details != null && details.didNotificationLaunchApp) {
//       onNotifications.add(details.payload!);
//     }
//
//     await notifications.initialize(settings,
//         onSelectNotification: (payload) async {
//       onNotifications.add(payload!);
//     });
//   }
//
//   static Future notificationDetails() async {
//     final bigPicturePath = await Utils.downloadFile(
//       url:
//           'https://images.pexels.com/photos/7324419/pexels-photo-7324419.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
//       fileName: 'bigPicture',
//     );
//     final largeIconPath = await Utils.downloadFile(
//       url:
//           'https://res.cloudinary.com/teepublic/image/private/s--Vny9nNHu--/t_Preview/b_rgb:ffffff,c_lpad,f_jpg,h_630,q_90,w_1200/v1585726530/production/designs/8796655_0.jpg',
//       fileName: 'largeIcon',
//     );
//
//     final styleInformation = BigPictureStyleInformation(
//       FilePathAndroidBitmap(bigPicturePath),
//       largeIcon: FilePathAndroidBitmap(largeIconPath),
//     );
//     return NotificationDetails(
//       android: AndroidNotificationDetails(
//         'channel id ',
//         'channel name',
//         channelDescription: 'channel description',
//         importance: Importance.max,
//         icon: "@mipmap/ic_launcher",
//         styleInformation: styleInformation,
//       ),
//       iOS: const IOSNotificationDetails(),
//     );
//   }
//
//   static Future showNotification(
//       {int id = 0, String? title, String? body, String? payload}) async {
//     notifications.show(
//       id,
//       title,
//       body,
//       await notificationDetails(),
//       payload: payload,
//     );
//   }
//
//   static tz.TZDateTime scheduleDaily(Time time) {
//     final now = tz.TZDateTime.now(tz.local);
//     final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
//         time.hour, time.minute, time.second);
//     return scheduledDate.isBefore(now)
//         ? scheduledDate.add(const Duration(days: 1))
//         : scheduledDate;
//   }
//
//   static tz.TZDateTime scheduleWeekly(Time time, {required List<int> days}) {
//     tz.TZDateTime scheduledDate = scheduleDaily(time);
//     while (!days.contains(scheduledDate.weekday)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }
//     return scheduledDate;
//   }
//
//   static Future showScheduledNotification({
//     int id = 0,
//     String? title,
//     String? body,
//     String? payload,
//     required DateTime scheduledDate,
//   }) async {
//     notifications.zonedSchedule(
//       id,
//       title,
//       body,
//       // to schedule at a specific time :
//       // tz.TZDateTime.from(scheduledDate, tz.local),
//       //to schedule daily:
//       // scheduleDaily(const Time(10,15)),
//       scheduleWeekly(
//         const Time(11),
//         days: [DateTime.monday, DateTime.friday],
//       ),
//       await notificationDetails(),
//       payload: payload,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       // to schedule at a specific time or daily:
//       // matchDateTimeComponents: DateTimeComponents.time,
//       // to schedule weekly:
//       // matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
//     );
//   }
// }
