import 'dart:convert';
import 'package:proacademy_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCache {
  static const _kUserJson = 'user_json';

  static Future<void> save(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUserJson, jsonEncode(user.toJson()));
  }

  static Future<UserModel?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kUserJson);
    if (raw == null || raw.isEmpty) return null;
    try {
      return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kUserJson);
  }
}
