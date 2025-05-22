import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:ootd_flutter/screens/NonLogin_firstscreen.dart';

class AuthService {
  // ✅ 로그아웃 (카카오 + Firebase)
  static Future<void> logout(BuildContext context) async {
    try {
      // ✅ 카카오 토큰 유효성 검사 & 로그아웃
      try {
        final tokenInfo = await kakao.UserApi.instance.accessTokenInfo();
        print('✅ 카카오 토큰 유효: ${tokenInfo.id}');

        await kakao.UserApi.instance.logout();
        print('✅ 카카오 로그아웃 성공!');
      } catch (e) {
        print('❌ 카카오 토큰 없음 또는 만료됨: $e');
      }

      // ✅ Firebase 로그아웃
      await firebase.FirebaseAuth.instance.signOut();
      print('✅ Firebase 로그아웃 성공!');

// ✅ context 유효할 때 화면 이동
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Firstscreen()), // 🔥 여기가 로그인 전 첫 화면으로 이동하는 부분
              (route) => false, // 스택 비우기 (뒤로가기 방지)
        );
      }


    } catch (e) {
      print('❌ 로그아웃 실패: $e');
    }
  }
}
