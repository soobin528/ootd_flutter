import 'package:flutter/material.dart';
import 'Email_Rg_screen.dart';
import 'login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import '../service/loginSv/kakaoAuth_service.dart';
import 'camera_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  KakaoSdk.init(
      nativeAppKey: 'c6ceea396ab6c11d19c4ebd13370d517');
  runApp(MaterialApp(home: Firstscreen()));
}

class Firstscreen extends StatelessWidget {
  const Firstscreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // 🔥 로고 이미지
              Image.asset(
                'assets/ootd_logo.png',
                width: 300,
                height: 400,
              ),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0079FD),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('이메일 로그인'),
                ),
              ),
              const SizedBox(height: 10),

              // ✅ 카카오 로그인 버튼
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () => AuthService.kakaoLogin(context), // ← 여기 이렇게 연결!
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFEE500),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('카카오 로그인'),
                ),
              ),
              const SizedBox(height: 10),


              // ✅ 네이버 로그인 버튼
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CameraScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF03C75A),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('키 체중 입력'),
                ),
              ),
              const SizedBox(height: 10),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EmailRegisterScreen()),
                  );
                },

                child: const Text('OOTD가 처음이시라고요? \n'
                    '\t\t\t\t\t\t\t\t\t 회원가입 하기',
                    style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
