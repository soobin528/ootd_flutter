import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final TextEditingController _heightController = TextEditingController();
final TextEditingController _weightController = TextEditingController();

Widget userBodySection() {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _heightController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: '키 (cm)',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _weightController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: '체중 (kg)',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      ElevatedButton(
        onPressed: _saveUserInfo,
        child: const Text('👤 정보 저장'),
      ),
    ],
  );
}

void _saveUserInfo() async {
  String height = _heightController.text;
  String weight = _weightController.text;

  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'height': height,
      'weight': weight,
      'timestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    print('✅ Firestore 저장 완료');
  } else {
    print('❌ 로그인 필요');
  }
}
