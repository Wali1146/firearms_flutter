import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firearm_flutter/config/config.dart';
import 'package:firearm_flutter/models/user_model.dart';

class UserServices {
  static final String baseUrl = Config.baseUrl;
  // LOGIN
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "email": email,
        "password": password,
      }),
    );
    final data = json.decode(response.body);
    if (response.statusCode == 200) {
      print("Response Login: ${response.body}");
      return data;
    } else {
      throw Exception("Login failed");
    }
  }

  // GET (READ)
  static Future<List<UserModel>> getUsers() async {
    final response = await http.get(Uri.parse("$baseUrl/users"));
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is List) {
        return decoded.map((e) => UserModel.fromJson(e)).toList();
      } else if (decoded is Map && decoded.containsKey('data')) {
        final List data = decoded['data'];
        return data.map((e) => UserModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception("Failed to load users");
    }
  }

  // POST (CREATE)
  static Future<void> addUser(UserModel user) async {
    final response = await http.post(
      Uri.parse("$baseUrl/users"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "username": user.username,
        "email": user.email,
        "password": user.password,
        "role": user.role,
      }),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception("Failed to add user");
    }
  }

  // PUT (UPDATE)
  static Future<void> updateUser(int id, UserModel user) async {
    final response = await http.put(
      Uri.parse("$baseUrl/users/$id"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "username": user.username,
        "email": user.email,
        "password": user.password,
        "role": user.role,
      }),
    );
    print("Response Update: ${response.body}");
    if (response.statusCode != 200) {
      throw Exception("Failed to update user");
    }
  }

  // DELETE
  static Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/users/$id"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete user");
    }
  }
}