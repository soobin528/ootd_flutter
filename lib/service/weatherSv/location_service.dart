import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LocationService {
  final String kakaoApiKey = '7c511320e40ff511365f6f7a4d683ad0'; // <- 꼭 바꿔줘

  /// 현재 위치 가져오기
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // GPS 서비스 활성화 체크
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('위치 서비스가 비활성화되어 있습니다.');
    }

    // 위치 권한 체크
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('위치 권한이 거부되었습니다.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('위치 권한이 영구적으로 거부되었습니다.');
    }

    // 현재 위치 반환
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Kakao API를 사용해서 한글 주소 얻기
  Future<String> getAddressFromLocation(double lat, double lon) async {
    final url = Uri.parse(
      'https://dapi.kakao.com/v2/local/geo/coord2address.json?x=$lon&y=$lat',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'KakaoAK 7c511320e40ff511365f6f7a4d683ad0', // 공백 꼭 있어야 해
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final documents = data['documents'] as List<dynamic>;

      if (documents.isNotEmpty) {
        final address = documents[0]['address']['address_name'];
        return address;
      } else {
        throw Exception('주소를 찾을 수 없습니다.');
      }
    } else {
      print('카카오 API 상태 코드: ${response.statusCode}');
      print('카카오 API 응답 본문: ${response.body}');
      throw Exception('Kakao 주소 변환 실패');
    }
  }
}
