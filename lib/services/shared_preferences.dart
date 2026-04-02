import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static Future<void> saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("id", int.parse(user['id'].toString()));
    await prefs.setString("username", user['username']);
    await prefs.setString("email", user['email']);
    await prefs.setString("role", user['role']);
    await prefs.setBool("isLogin", true);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLogin") ?? false;
  }

  static Future<Map<String, dynamic>> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "id": prefs.getInt("id"),
      "username": prefs.getString("username"),
      "email": prefs.getString("email"),
      "role": prefs.getString("role"),
    };
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}