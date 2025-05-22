import 'package:flutter/material.dart';
import 'setting_screen.dart';

class AvatarCreateScreen extends StatefulWidget {
  const AvatarCreateScreen({super.key});

  @override
  State<AvatarCreateScreen> createState() => _AvatarCreateScreenState();
}

class _AvatarCreateScreenState extends State<AvatarCreateScreen> {
  String? selectedGender;
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  String userName = '영재'; // 없으면 "사용자"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          },
        ),
        title: const Text(
          '아바타 생성',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),


      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Text(
                '아바타 생성을 위한',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '사진 등록과 정보를 입력해주세요!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 32),

              /// 사진 버튼 2개
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _photoButton(
                    icon: Icons.camera_alt_outlined,
                    label: "사진 찍기",
                    bgColor: const Color(0xFFB9E4DC),
                    onTap: () {
                      // TODO: 카메라 연동
                    },
                  ),
                  const SizedBox(width: 24),
                  _photoButton(
                    icon: Icons.insert_drive_file_outlined,
                    label: "파일 선택",
                    bgColor: const Color(0xFFD9C7F3),
                    onTap: () {
                      // TODO: 갤러리 연동
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// 성별 선택
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _genderRadio("여자"),
                  const SizedBox(width: 20),
                  _genderRadio("남자"),
                ],
              ),
              const SizedBox(height: 24),

              /// 키 입력
              _customInputField(
                controller: heightController,
                label: "키(cm)",
              ),
              const SizedBox(height: 16),

              /// 체중 입력
              _customInputField(
                controller: weightController,
                label: "체중(kg)",
              ),
              const SizedBox(height: 32),

              /// 확인 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: 저장 로직
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C7AE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    '확인',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// 환영 메시지
              Text(
                userName.isNotEmpty
                    ? "$userName님, 환영합니다!\n아바타를 만들어보세요 ⭐"
                    : "사용자님, 환영합니다!\n아바타를 만들어보세요 ⭐",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 성별 선택 라디오
  Widget _genderRadio(String gender) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: gender,
          groupValue: selectedGender,
          onChanged: (val) {
            setState(() {
              selectedGender = val;
            });
          },
          activeColor: const Color(0xFF00C7AE),
        ),
        Text(gender, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  /// 입력 필드
  Widget _customInputField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const UnderlineInputBorder(),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF00C7AE), width: 2),
        ),
      ),
    );
  }

  /// 사진 버튼 박스
  Widget _photoButton({
    required IconData icon,
    required String label,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, size: 40, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
 