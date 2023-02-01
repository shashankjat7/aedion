import 'dart:developer';

class SecondsToTime {
  String convertToTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = ((seconds % 3600) % 60);
    return ('${hours}h ${minutes}m ${secs}s');
  }
}
