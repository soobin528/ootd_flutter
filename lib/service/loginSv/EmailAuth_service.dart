import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../screens/weather_screen.dart'; // ✅ 로그인 화면 생기면 수정하세요.

class EmailAuthService {
  static Future<void> registerUser(
      BuildContext context, String email, String password, String confirmPassword) async {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 필드를 입력하세요.')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입 성공!')),
      );

      // ✅ 현재는 WeatherScreen으로 이동, 로그인 화면 생기면 아래 주석처럼 수정하세요.
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WeatherScreen()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 실패: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('알 수 없는 오류가 발생했습니다.')),
      );
    }
  }
}
