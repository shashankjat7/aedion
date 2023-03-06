import 'dart:developer';

import 'package:aedion/Modules/Tasks/models/task_model.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

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
