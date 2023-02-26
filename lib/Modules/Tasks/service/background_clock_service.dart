// this code contains all the services required to run a clock while app is closed

import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:aedion/Modules/Tasks/models/task_model.dart';
import 'package:aedion/main.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

class BackgroundClockService {
  void callBackgroundClock(TaskModel task) async {
    log('call background clock called');
    FlutterBackgroundService().startService();
    FlutterBackgroundService().invoke('setAsBackground', {
      'time': task.timeSpent,
    });
  }

  void removeBackgroundClock() async {
    log('Cancel all tasks completed');
    FlutterBackgroundService().invoke('stopService');
  }
}
