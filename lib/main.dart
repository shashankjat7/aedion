import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';
import 'dart:io';

import 'package:aedion/Modules/HomeScreen/views/home_screen_view.dart';
import 'package:aedion/Modules/Tasks/SubModules/CreateNewTask/views/create_task_view.dart';
import 'package:aedion/Modules/Tasks/service/background_clock_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'Modules/Authentication/views/sign_in_view.dart';
import 'Modules/Tasks/blocs/task_list_bloc.dart';
import 'back_test.dart';

String initialRoute = SignInView.routeName;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (FirebaseAuth.instance.currentUser != null) {
    initialRoute = HomeScreenView.routeName;
  }

  // notification settings

  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //
  // AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
  //
  // final InitializationSettings initializationSettings = InitializationSettings(
  //   android: initializationSettingsAndroid,
  // );
  // await flutterLocalNotificationsPlugin.initialize(
  //   initializationSettings,
  //   onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  // );
  initializeService();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskListBloc()..add(TaskListFetch()),
      child: MaterialApp(
        title: 'Aedion',
        debugShowCheckedModeBanner: false,
        routes: {
          SignInView.routeName: (context) => const SignInView(),
          HomeScreenView.routeName: (context) => HomeScreenView(),
          CreateTaskPageView.routeName: (context) => CreateTaskPageView(),
        },
        initialRoute: initialRoute,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
