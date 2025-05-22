import 'package:flutter/material.dart';

final ThemeData ootdTheme = ThemeData(
  useMaterial3: true, // 최신 스타일 적용 (선택사항)
  scaffoldBackgroundColor: const Color(0xFFFAF7F2), // 감성 배경 베이지

  fontFamily: 'Pretendard', // pubspec.yaml에 폰트 등록 시

  colorScheme: const ColorScheme.light(
    primary: Color(0xFF00C7AE),     // 민트 포인트
    secondary: Color(0xFFD9C7F3),   // 연보라 보조 포인트
    background: Color(0xFFFAF7F2),
    onPrimary: Colors.white,
    onSecondary: Colors.black87,
    onBackground: Colors.black87,
    surface: Colors.white,
    onSurface: Colors.black87,
  ),

  textTheme: const TextTheme(
    headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
    bodyLarge: TextStyle(fontSize: 16),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(color: Colors.black87, fontSize: 20),
    iconTheme: IconThemeData(color: Colors.black87),
  ),

  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: Colors.black87),
    border: UnderlineInputBorder(),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF00C7AE), width: 2),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF00C7AE),
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14),
    ),
  ),
);
