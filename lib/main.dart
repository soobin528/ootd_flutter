import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:firebase_core/firebase_core.dart';
import 'screens/weather_screen.dart';
import 'screens/NonLogin_firstscreen.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'screens/avatarinfomodify_screen.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  kakao.KakaoSdk.init(nativeAppKey: 'c6ceea396ab6c11d19c4ebd13370d517');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> isKakaoLoggedIn() async {
    try {
      final kakao.User user = await kakao.UserApi.instance.me();
      return user.id != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OOTD',
      debugShowCheckedModeBanner: false,
      theme: ootdTheme,
      home: FutureBuilder<bool>(
        future: checkLoginStatus(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data == true) {
            return const WeatherScreen(); // 로그인 O
          } else {
            return const Firstscreen(); // 로그인 X
          }
        },
      ),
    );
  }

  Future<bool> checkLoginStatus() async {
    final firebaseUser = fb_auth.FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) return true;

    final kakaoLoggedIn = await isKakaoLoggedIn();
    return kakaoLoggedIn;
  }
}
