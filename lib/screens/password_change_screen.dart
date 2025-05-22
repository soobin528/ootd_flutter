import 'package:flutter/material.dart';
import '../service/loginsv/PasswordChange_service.dart';
import 'myinfo_screen.dart';

class PasswordChangeScreen extends StatefulWidget {
  const PasswordChangeScreen({super.key});

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final currentPwController = TextEditingController();
  final newPwController = TextEditingController();
  final confirmPwController = TextEditingController();

  bool showCurrentPw = false;
  bool showNewPw = false;
  bool showConfirmPw = false;
  bool pwChanged = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        title: const Text('비밀번호', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            _label('현재 비밀번호'),
            TextField(
              controller: currentPwController,
              obscureText: !showCurrentPw,
              decoration: InputDecoration(
                hintText: '현재 비밀번호를 입력해주세요',
                suffixIcon: IconButton(
                  icon: Icon(showCurrentPw ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() => showCurrentPw = !showCurrentPw);
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            _label('새로운 비밀번호'),
            TextField(
              controller: newPwController,
              obscureText: !showNewPw,
              decoration: InputDecoration(
                hintText: '영문, 숫자 포함 10글자 이상',
                suffixIcon: IconButton(
                  icon: Icon(showNewPw ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() => showNewPw = !showNewPw);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPwController,
              obscureText: !showConfirmPw,
              decoration: InputDecoration(
                hintText: '비밀번호를 한 번 더 입력해주세요',
                suffixIcon: IconButton(
                  icon: Icon(showConfirmPw ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() => showConfirmPw = !showConfirmPw);
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  PasswordChangeService.changePassword(
                    context: context,
                    currentPassword: currentPwController.text.trim(),
                    newPassword: newPwController.text.trim(),
                    confirmPassword: confirmPwController.text.trim(),
                    onSuccess: () {
                      setState(() => pwChanged = true);
                      Future.delayed(const Duration(seconds: 1), () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const MyInfoScreen()),
                        );
                      });
                    },
                  );
                },
                child: const Text('확인', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
            if (pwChanged)
              const Center(
                child: Text(
                  '비밀번호가 변경되었습니다',
                  style: TextStyle(color: Color(0xFF00C7AE), fontSize: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
      ],
    );
  }
}
