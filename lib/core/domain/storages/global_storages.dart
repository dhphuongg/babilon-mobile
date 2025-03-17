import 'package:babilon/presentation/pages/root/root_screen.dart';
import 'package:flutter/material.dart';

class GlobalStorage {
  // Initial Widget
  static Widget initialRoute = const RootScreen();
  static bool? haveDialogError = false;

  static String accessToken = '';
  static bool hasInternetConnect = false;
}
