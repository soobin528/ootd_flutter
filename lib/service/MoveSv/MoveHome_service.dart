import 'package:flutter/material.dart';

class NavigationService {
  static void MoveMain(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/');
    // 또는 명시적으로:
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()));
  }
}
