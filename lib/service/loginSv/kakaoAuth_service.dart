import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../screens/weather_screen.dart'; // 경로 맞게 수정!

class AuthService {
  // ✅ Firestore에 카카오 사용자 정보 저장
  static Future<void> saveKakaoUserInfo(kakao.User kakaoUser) async {
    final uid = kakaoUser.id.toString();
    final email = kakaoUser.kakaoAccount?.email ?? '${uid}@kakao.com';
    final name = kakaoUser.kakaoAccount?.profile?.nickname ?? '이름 없음';

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'phone': '',
      'height': '0',
      'weight': '0',
      'image_url': '',
      'last_upload': Timestamp.now(),
      'timestamp': Timestamp.now(),
    }, SetOptions(merge: true));

    print('✅ Firestore에 카카오 사용자 정보 저장 완료!');
  }

  // ✅ Firebase에 카카오 사용자 등록 + 세션 유지 확실히!
  static Future<void> registerWithFirebase(kakao.User kakaoUser) async {
    final email = kakaoUser.kakaoAccount?.email ?? '${kakaoUser.id}@kakao.com';
    final password = kakaoUser.id.toString();

    try {
      final methods = await firebase.FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      if (methods.isNotEmpty) {
        try {
          // 이미 등록된 경우 → 로그인 시도
          await firebase.FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          print('✅ Firebase 기존 계정 로그인 성공!');
        } catch (e) {
          print('❌ Firebase 로그인 실패 (비밀번호 불일치 등): $e');
          // 👉 여기서 다른 소셜 연동 처리 필요할 수 있음. (지금은 패스)
        }
      } else {
        // 새 계정 생성
        await firebase.FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        print('✅ Firebase 새 계정 생성 & 로그인 성공!');
      }
    } catch (e) {
      print('❌ Firebase 계정 처리 실패: $e');
    }
  }

  // ✅ 카카오 로그인 + Firebase 세션 연동 + Firestore 저장 + 화면 이동
  static Future<void> kakaoLogin(BuildContext context) async {
    try {
      kakao.OAuthToken token = await kakao.UserApi.instance.loginWithKakaoAccount();
      print('카카오 로그인 성공! 액세스 토큰: ${token.accessToken}');

      kakao.User kakaoUser = await kakao.UserApi.instance.me();
      print('카카오 이메일: ${kakaoUser.kakaoAccount?.email}');

      // ✅ Firebase Auth 연동 (세션 확실히 잡기)
      await registerWithFirebase(kakaoUser);

      // ✅ Firestore에 사용자 정보 저장
      await saveKakaoUserInfo(kakaoUser);

      // ✅ WeatherScreen으로 이동 (context 안전 체크)
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WeatherScreen()),
        );
      }
    } catch (e) {
      print('❌ 로그인 실패: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인 실패: ${e.toString()}')),
        );
      }
    }
  }
}
