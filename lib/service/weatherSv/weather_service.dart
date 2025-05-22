import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = '813387898c469adb865d6fb021397c4f'; // 여기다가 발급받은 키 넣어!

  Future<Map<String, dynamic>> getWeatherByLocation(double lat, double lon) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=kr',

    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('위치 기반 날씨 정보를 가져오는 데 실패했습니다.');
    }
  }


  Future<Map<String, dynamic>> getWeather(String cityName) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric&lang=kr',

    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      // 요청 성공
      return json.decode(response.body);
    } else {
      // 요청 실패
      throw Exception('날씨 정보를 가져오는 데 실패했습니다.');
    }
  }
}
