import 'package:flutter/material.dart';
import '../service/loginSv/EmailAuth_service.dart';

class EmailRegisterScreen extends StatefulWidget {
  const EmailRegisterScreen({super.key});

  @override
  State<EmailRegisterScreen> createState() => _EmailRegisterScreenState();
}

class _EmailRegisterScreenState extends State<EmailRegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: SingleChildScrollView( // ✅ 스크롤 가능하도록 추가
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'OOTD\n간편하게 로그인하고\n다양한 서비스를 이용하세요.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: '이메일주소'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: '비밀번호 (영문 숫자 포함 10자 이상)'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: '비밀번호 재입력'),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    EmailAuthService.registerUser(
                      context,
                      emailController.text.trim(),
                      passwordController.text.trim(),
                      confirmPasswordController.text.trim(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('다음'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
