import 'dart:io';

import 'package:aedion/Modules/Compass/views/compass_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePageView extends StatefulWidget {
  HomePageView({Key? key}) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Future<void> initializeService() async {
  //   final service = FlutterBackgroundService();
  //
  //   /// OPTIONAL, using custom notification channel id
  //   const AndroidNotificationChannel channel = AndroidNotificationChannel(
  //     'my_foreground', // id
  //     'MY FOREGROUND SERVICE', // title
  //     description: 'This channel is used for important notifications.', // description
  //     importance: Importance.low, // importance must be at low or higher level
  //   );
  //
  //   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //
  //   await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  //
  //   await service.configure(
  //     androidConfiguration: AndroidConfiguration(
  //       // this will be executed when app is in foreground or background in separated isolate
  //       onStart: onStart,
  //
  //       // auto start service
  //       autoStart: true,
  //       isForegroundMode: true,
  //
  //       notificationChannelId: 'my_foreground',
  //       initialNotificationTitle: 'AWESOME SERVICE',
  //       initialNotificationContent: 'Initializing',
  //       foregroundServiceNotificationId: 888,
  //     ),
  //     iosConfiguration: IosConfiguration(
  //       // auto start service
  //       autoStart: true,
  //
  //       // this will be executed when app is in foreground in separated isolate
  //       // onForeground: onStart,
  //
  //       // you have to enable background fetch capability on xcode project
  //       // onBackground: onIosBackground,
  //     ),
  //   );
  //
  //   service.startService();
  // }

  void showOngoingNotification() async {
    // final int progressId = 10;
    // const int maxProgress = 5;
    // for (int i = 0; i <= 1000; i++) {
    //   await Future<void>.delayed(const Duration(seconds: 1), () async {
    //     final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    //       'progress channel',
    //       'progress channel',
    //       channelDescription: 'progress channel description',
    //       channelShowBadge: false,
    //       importance: Importance.max,
    //       priority: Priority.high,
    //       onlyAlertOnce: true,
    //       showProgress: false,
    //       // maxProgress: maxProgress,
    //       progress: i,
    //       ongoing: false,
    //     );
    //     final NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    //     await flutterLocalNotificationsPlugin.show(
    //       progressId,
    //       'progress notification title',
    //       '$i',
    //       notificationDetails,
    //       payload: 'item x',
    //     );
    //   });
    // }

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'ongoing_notification_id',
      'Ongoing Notification',
      channelDescription: 'This is the channel description',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: true,
      autoCancel: false,
      ticker: 'ticker',
      when: DateTime.now().millisecondsSinceEpoch - 26087 * 1000,
      usesChronometer: true,
      chronometerCountDown: false,
      actions: <AndroidNotificationAction>[
        const AndroidNotificationAction(
          'text_id_1',
          'Pause notification',
          // icon: DrawableResourceAndroidBitmap('food'),
          cancelNotification: false,
        ),
        const AndroidNotificationAction(
          'text_id_2',
          'Close Notification',
          // icon: DrawableResourceAndroidBitmap('food'),
          cancelNotification: true,
        ),
      ],
    );
    NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      5,
      'Learn ML',
      'Ongoing Task',
      notificationDetails,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                showOngoingNotification();
              },
              child: const Text('Show ongoing notification'),
            ),
          ],
        ),
      ),
    );
  }
}
