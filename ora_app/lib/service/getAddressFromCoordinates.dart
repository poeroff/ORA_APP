import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

class GetAddress {
  Future<String> getAddressFromCoordinates(double lat, double lng) async {
    try {
      final clientKey = dotenv.env["NAVER_CLIENTKEY"];
      final secretKey = dotenv.env["NAVER_SECRET_KEY"];

      if (clientKey == null || secretKey == null) {
        throw Exception('API 키가 없습니다.');
      }

      final url =
          'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?coords=$lng,$lat&output=json&orders=legalcode,admcode,addr,roadaddr';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'X-NCP-APIGW-API-KEY-ID': clientKey,
          'X-NCP-APIGW-API-KEY': secretKey,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          final region = data['results'][0]['region'];
          return '${region['area1']['name']} ${region['area2']['name']} ${region['area3']['name']}';
        } else {
          throw Exception('주소 데이터가 없습니다.');
        }
      } else {
        throw Exception('주소 로드 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('getAddressFromCoordinates 오류: $e');
      rethrow;
    }
  }
}
