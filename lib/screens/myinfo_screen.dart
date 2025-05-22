import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'password_change_screen.dart';
import '../service/loginSv/Logout_service.dart';

class MyInfoScreen extends StatelessWidget {
  const MyInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final String name = user?.displayName ?? '이름 없음';
    final String email = user?.email ?? '이메일 없음';
    final String phoneNumber = user?.phoneNumber ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
          color: Colors.black,
        ),
        title: const Text(
          '내 정보',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 8),
            _infoRow('이름', name),
            _infoRow('이메일', email),
            _arrowRow(
              label: '비밀번호',
              value: '••••••••',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PasswordChangeScreen()),
                );
              },
            ),
            _arrowRow(
              label: '휴대폰',
              value: phoneNumber.isNotEmpty ? phoneNumber : '연락처 없음',
              isHint: phoneNumber.isEmpty,
              onTap: () {
                // TODO: 연락처 수정 화면
              },
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  if (context.mounted) {
                    await AuthService.logout(context);
                  }
                },
                style: ButtonStyle(
                  side: MaterialStateProperty.all(
                    const BorderSide(color: Color(0xFF00C7AE)),
                  ),
                  foregroundColor: MaterialStateProperty.all(const Color(0xFF00C7AE)),
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                        (states) =>
                    states.contains(MaterialState.pressed) ? const Color(0xFFD9C7F3) : null,
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                child: const Text('로그아웃', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 14, color: Colors.black)),
            Text(value, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
        const Divider(height: 24, thickness: 1, color: Colors.black12),
      ],
    );
  }

  Widget _arrowRow({
    required String label,
    required String value,
    bool isHint = false,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(label, style: const TextStyle(fontSize: 14, color: Colors.black)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 16, color: isHint ? Colors.grey : Colors.grey),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
          onTap: onTap,
        ),
        const Divider(height: 0, thickness: 1, color: Colors.black12),
      ],
    );
  }
}
