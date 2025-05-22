import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordChangeService {
  static Future<void> changePassword({
    required BuildContext context,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
    required VoidCallback onSuccess,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 필드를 입력해주세요.')),
      );
      return;
    }

    if (newPassword.length < 10 ||
        !RegExp(r'[A-Za-z]').hasMatch(newPassword) ||
        !RegExp(r'\d').hasMatch(newPassword)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('새 비밀번호는 영문, 숫자를 포함해 10자 이상이어야 합니다.')),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('새 비밀번호가 일치하지 않습니다.')),
      );
      return;
    }

    try {
      final cred = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호가 성공적으로 변경되었습니다.')),
      );

      onSuccess();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('현재 비밀번호가 올바르지 않습니다.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류 발생: ${e.message}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('알 수 없는 오류가 발생했습니다.')),
      );
    }
  }
}
