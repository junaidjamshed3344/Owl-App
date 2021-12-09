import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences _prefs;

  static SharedPreferences get prefs => _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
}
