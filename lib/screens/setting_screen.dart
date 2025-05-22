import 'package:flutter/material.dart';
import '../service/user_settingSv/settings_service.dart';
import 'avatarinfomodify_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isNotificationOn = false;

  void _showNotificationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "알림 설정",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "알림이 꺼져 있어요. 지금은 새로운 소식을 받아도\n"
                      "알림이 전송되지 않아요.\n\n"
                      "알림 허용을 위해 이동하시겠어요?",
                  style: TextStyle(
                    fontSize: 14.5,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "나중에",
                        style: TextStyle(
                          color: Color(0xFF03C75A),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isNotificationOn = true; // ✅ 이때만 ON으로 바뀜
                        });
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: const Text(
                        "설정하러 가기",
                        style: TextStyle(fontSize: 14.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('내 정보'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              SettingsService.goToMyInfoScreen(context);
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('아바타 정보'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AvatarCreateScreen()),
              );
            },
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text('알림 받기'),
            value: isNotificationOn,
            onChanged: (value) {
              if (value) {
                // ✅ OFF → ON 시도 → 팝업 띄우고, 확인해야 진짜 ON됨
                _showNotificationDialog();
              } else {
                // ✅ ON → OFF 는 그냥 꺼짐
                setState(() {
                  isNotificationOn = false;
                });
              }
            },
            activeColor: const Color(0xFF03C75A), // 초록 불
            inactiveThumbColor: Colors.black,     // 기본 꺼진 상태: 검정색
            inactiveTrackColor: Colors.black12,
          ),
        ],
      ),
    );
  }
}
