import 'package:shared_preferences/shared_preferences.dart';

// A class to manage session tokens in shared preferences.
class SessionManager {
  static const String _sessionKey = 'favouriteCities';

  // Method to check if it is the first time the user is using the app.
  static Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionToken = prefs.getStringList(_sessionKey);
    return sessionToken == null;
  }

  // Method to retrieve the session token.
  static Future<List<String>?> getSessionDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_sessionKey);
  }

  // Method to set the session token.
  static Future<void> setSessionDetails(List<String> cityList) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_sessionKey, cityList);
  }

  // Method to clear session token.
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}
