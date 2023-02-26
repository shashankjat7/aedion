import 'dart:developer';
import 'dart:io';

import 'package:aedion/Modules/Compass/views/compass_view.dart';
import 'package:aedion/Modules/Tasks/blocs/task_list_bloc.dart';
import 'package:aedion/Modules/Tasks/service/background_clock_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePageView extends StatefulWidget {
  HomePageView({Key? key}) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> with WidgetsBindingObserver {
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

  // void showOngoingNotification() async {
  //   // final int progressId = 10;
  //   // const int maxProgress = 5;
  //   // for (int i = 0; i <= 1000; i++) {
  //   //   await Future<void>.delayed(const Duration(seconds: 1), () async {
  //   //     final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
  //   //       'progress channel',
  //   //       'progress channel',
  //   //       channelDescription: 'progress channel description',
  //   //       channelShowBadge: false,
  //   //       importance: Importance.max,
  //   //       priority: Priority.high,
  //   //       onlyAlertOnce: true,
  //   //       showProgress: false,
  //   //       // maxProgress: maxProgress,
  //   //       progress: i,
  //   //       ongoing: false,
  //   //     );
  //   //     final NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
  //   //     await flutterLocalNotificationsPlugin.show(
  //   //       progressId,
  //   //       'progress notification title',
  //   //       '$i',
  //   //       notificationDetails,
  //   //       payload: 'item x',
  //   //     );
  //   //   });
  //   // }
  //
  //   AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
  //     'ongoing_notification_id',
  //     'Ongoing Notification',
  //     channelDescription: 'This is the channel description',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     ongoing: true,
  //     autoCancel: false,
  //     ticker: 'ticker',
  //     when: DateTime.now().millisecondsSinceEpoch - 26087 * 1000,
  //     usesChronometer: true,
  //     chronometerCountDown: false,
  //     actions: <AndroidNotificationAction>[
  //       const AndroidNotificationAction(
  //         'text_id_1',
  //         'Pause notification',
  //         // icon: DrawableResourceAndroidBitmap('food'),
  //         cancelNotification: false,
  //       ),
  //       const AndroidNotificationAction(
  //         'text_id_2',
  //         'Close Notification',
  //         // icon: DrawableResourceAndroidBitmap('food'),
  //         cancelNotification: true,
  //       ),
  //     ],
  //   );
  //   NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
  //   await flutterLocalNotificationsPlugin.show(
  //     5,
  //     'Learn ML',
  //     'Ongoing Task',
  //     notificationDetails,
  //   );
  // }

  final service = FlutterBackgroundService();
  String text = "Stop Service";
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        log('appLifeCycleState inactive');
        break;
      case AppLifecycleState.resumed:
        // BackgroundClockService().removeBackgroundClock();
        log('appLifeCycleState resumed');
        break;
      case AppLifecycleState.paused:
        log('appLifeCycleState paused');
        break;
      case AppLifecycleState.detached:
        log('appLifeCycleState detached');
        break;
    }
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
            TextButton(
              onPressed: () {
                context.read<TaskListBloc>().add(TaskListAppClosed());
              },
              child: Text('Start service'),
            ),
            TextButton(
              onPressed: () {
                BackgroundClockService().removeBackgroundClock();
              },
              child: Text('Stop service'),
            ),
          ],
        ),
      ),
      // Column(
      //   children: [
      //     StreamBuilder<Map<String, dynamic>?>(
      //       stream: FlutterBackgroundService().on('update'),
      //       builder: (context, snapshot) {
      //         if (!snapshot.hasData) {
      //           return const Center(
      //             child: CircularProgressIndicator(),
      //           );
      //         }
      //
      //         final data = snapshot.data!;
      //         String? device = data["device"];
      //         DateTime? date = DateTime.tryParse(data["current_date"]);
      //         return Column(
      //           children: [
      //             Text(device ?? 'Unknown'),
      //             Text(date.toString()),
      //           ],
      //         );
      //       },
      //     ),
      //     ElevatedButton(
      //       child: const Text("Foreground Mode"),
      //       onPressed: () {
      //         FlutterBackgroundService().invoke("setAsForeground");
      //       },
      //     ),
      //     ElevatedButton(
      //       child: const Text("Background Mode"),
      //       onPressed: () {
      //         FlutterBackgroundService().invoke("setAsBackground");
      //       },
      //     ),
      //     ElevatedButton(
      //       child: Text(text),
      //       onPressed: () async {
      //         final service = FlutterBackgroundService();
      //         var isRunning = await service.isRunning();
      //         if (isRunning) {
      //           service.invoke("stopService");
      //         } else {
      //           service.startService();
      //         }
      //
      //         if (!isRunning) {
      //           text = 'Stop Service';
      //         } else {
      //           text = 'Start Service';
      //         }
      //         setState(() {});
      //       },
      //     ),
      //   ],
      // ),
    );
  }
}
