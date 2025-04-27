import 'package:flutter/material.dart';
import 'package:babilon/core/application/api/object_response.dart';
import 'package:babilon/core/domain/utils/share_preferences.dart';

Future<String> getAccessToken() async {
  final String token = await SharedPreferencesHelper.getStringValue(
      SharedPreferencesHelper.ACCESS_TOKEN);
  return token;
}

class Utils {
  static getScreenWidth(context) => MediaQuery.of(context).size.width;

  static getScreenHeight(context) => MediaQuery.of(context).size.height;
}

extension ObjectResponseUtils<T> on ObjectResponse<T> {
  bool get isSuccess => success == true;
}
