import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

Future<void> pickImage(BuildContext context) async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    String? imageUrl = await _uploadImageToFirebase(File(image.path));

    if (imageUrl != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('📁 이미지 업로드 성공!')),
      );
      await _saveImageUrlToFirestore(imageUrl);
    }
  }
}

Future<String?> _uploadImageToFirebase(File file) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('user_images/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg');

    await storageRef.putFile(file);
    return await storageRef.getDownloadURL();
  } catch (e) {
    print('❌ 이미지 업로드 실패: $e');
    return null;
  }
}

Future<void> _saveImageUrlToFirestore(String imageUrl) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'image_url': imageUrl,
    }, SetOptions(merge: true));

    print('✅ 이미지 URL Firestore 저장 완료');
  }
}
