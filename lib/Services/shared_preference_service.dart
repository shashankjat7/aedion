import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  void setStringList(String key, List<String> stringList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, stringList);
  }
}
