import 'package:shared_preferences/shared_preferences.dart';

class DemoAuthStorage {
  static const _loggedInKey = 'demo_logged_in';

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, value);
  }

  static Future<void> logout() => setLoggedIn(false);
}
