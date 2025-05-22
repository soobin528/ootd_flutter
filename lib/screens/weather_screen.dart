import 'package:flutter/material.dart';
import '../service/weatherSv/weather_service.dart';
import '../service/weatherSv/location_service.dart';
import '../service/MoveSv/MoveHome_service.dart';
import '../service/loginSv/Logout_service.dart';
import 'setting_screen.dart';



class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();
  Map<String, dynamic>? _weatherData;
  String? _address;

  @override
  void initState() {
    super.initState();
    _loadWeatherAndAddress();
  }

  Future<void> _loadWeatherAndAddress() async {
    try {
      final position = await _locationService.getCurrentLocation();
      final address = await _locationService.getAddressFromLocation(
        position.latitude,
        position.longitude,
      );
      final weatherData = await _weatherService.getWeatherByLocation(
        position.latitude,
        position.longitude,
      );
      setState(() {
        _address = address;
        _weatherData = weatherData;
      });
    } catch (e) {
      print('에러 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('정보를 가져오는데 실패했습니다.')),
      );
    }
  }

  String getBackgroundImage(String description) {
    if (description.contains('맑음')) {
      return 'assets/sunny.jpg';
    } else if (description.contains('구름')) {
      return 'assets/cloudy.jpg';
    } else if (description.contains('비')) {
      return 'assets/rain.gif';
    } else if (description.contains('눈')) {
      return 'assets/snow.jpg';
    } else {
      return 'assets/sunny.jpg'; // 기본값
    }
  }

  @override
  Widget build(BuildContext context) {
    final description = _weatherData?['weather'][0]['description'] ?? '';

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_weatherData != null)
            Image.asset(
              getBackgroundImage(description),
              fit: BoxFit.cover,
            ),
          Container(
            color: Colors.black.withOpacity(0.3), // 배경 위에 반투명 레이어
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Row(
              children: [
                // 홈 버튼
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.white, size: 30),
                  onPressed: () {
                    NavigationService.MoveMain(context); // ✅ 홈 이동
                  },
                ),
                // 설정화면
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsScreen()), // ✅ settings_screen.dart로 이동
                    );
                  },
                ),

              ],
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _weatherData != null && _address != null
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,  // 중앙 정렬 추가!!
                crossAxisAlignment: CrossAxisAlignment.center, // 텍스트도 중앙 정렬
                children: [
                  Text(
                    _address!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_weatherData!['main']['temp'].toStringAsFixed(1)}°C',
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20), // 간격 살짝 주고


                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 450,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/avatar.png'), // ← 아바타 이미지 경로
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
