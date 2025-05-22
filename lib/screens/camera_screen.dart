import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../service/user_settingSv/userbody_service.dart'; // 기존 키/체중 입력 코드 import

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  String? latestImageUrl;

  @override
  void initState() {
    super.initState();
    _loadLatestImage();
  }

  Future<void> _loadLatestImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        latestImageUrl = doc['image_url'];
      });
    }
  }

  Future<void> _pickAndUploadImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image == null) return;

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("로그인이 필요합니다!")),
        );
        return;
      }

      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images/${user.uid}/$fileName.jpg');

      await storageRef.putData(await image.readAsBytes());

      String downloadURL = await storageRef.getDownloadURL();

      // Firestore에 사진 URL 저장
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'image_url': downloadURL,
        'last_upload': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      setState(() {
        latestImageUrl = downloadURL;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ 사진 업로드 완료!")),
      );
    } catch (e) {
      print("❌ 업로드 실패: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("사진 업로드에 실패했습니다.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('카메라 & 체형 정보 입력')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _pickAndUploadImage(ImageSource.camera),
                child: const Text('📷 카메라로 촬영 & 업로드'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _pickAndUploadImage(ImageSource.gallery),
                child: const Text('🖼️ 갤러리에서 선택 & 업로드'),
              ),
              const SizedBox(height: 30),
              if (latestImageUrl != null) ...[
                const Text("📌 최신 사진 미리보기"),
                const SizedBox(height: 10),
                Image.network(
                  latestImageUrl!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ] else
                const Text("📂 업로드된 사진이 없습니다."),
              const SizedBox(height: 30),
              userBodySection(), // 키 & 체중 입력 + Firestore 저장
            ],
          ),
        ),
      ),
    );
  }
}
