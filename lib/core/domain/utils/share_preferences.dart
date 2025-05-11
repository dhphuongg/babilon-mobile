// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  // as String
  static const String ACCESS_TOKEN = 'accessToken';
  static const String REFRESH_TOKEN = 'refreshToken';
  static const String USER_ID = 'userId';
  static const String FULL_NAME = 'fullName';
  static const String USERNAME = 'username';
  static const String AVATAR = 'avatar';
  static const String SIGNATURE = 'signature';
  static const String DEVICE_TOKEN = 'deviceToken';

  /// Store String value locally.
  /// [key] The key of saved value, which will be used later when getting
  /// the value.
  /// [value] The value to be saved
  static Future<bool> saveStringValue(String key, String value) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setString(key, value);
  }

  /// Get stored value from local storage.
  /// [key] The key to identify the value we get.
  static Future<String> getStringValue(String key) async {
    final preferences = await SharedPreferences.getInstance();
    final value = preferences.getString(key) ?? '';
    return value;
  }

  static Future<void> removeByKey(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static Future<void> savePoints(
      String id, List<Map<String, double>> points) async {
    final prefs = await SharedPreferences.getInstance();
    final String pointsJson = jsonEncode(points);
    await prefs.setString(id, pointsJson);
  }

  /// Retrieve the list of points.
  static Future<List<Map<String, double>>?> getPoints(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? pointsJson = prefs.getString(id);
    if (pointsJson != null) {
      final List<dynamic> pointsList = jsonDecode(pointsJson);
      return pointsList
          .map((point) => Map<String, double>.from(point))
          .toList();
    } else {
      return null;
    }
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
