import 'package:flutter/material.dart';
import '../../screens/myinfo_screen.dart';

class SettingsService {
  static Future<void> goToMyInfoScreen(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MyInfoScreen()),
    );
  }
}
