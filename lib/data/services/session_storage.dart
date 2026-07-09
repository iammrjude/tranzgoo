import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tranzgoo/data/models/app_user.dart';
import 'package:tranzgoo/data/models/auth_session.dart';

class SessionStorage {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  Future<void> saveSession(AuthSession session) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(_tokenKey, session.token);
    await preferences.setString(_userKey, jsonEncode(session.user.toJson()));
  }

  Future<String?> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_tokenKey);
  }

  Future<AppUser?> getUser() async {
    final preferences = await SharedPreferences.getInstance();
    final rawUser = preferences.getString(_userKey);

    if (rawUser == null || rawUser.isEmpty) {
      return null;
    }

    final decoded = jsonDecode(rawUser);

    if (decoded is! Map<String, dynamic>) {
      return null;
    }

    return AppUser.fromJson(decoded);
  }

  Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.remove(_tokenKey);
    await preferences.remove(_userKey);
  }
}
