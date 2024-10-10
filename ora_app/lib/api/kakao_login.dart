import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

class KakaoLogin {
  static String apiUri = "${dotenv.env["NODE_BACKEND_ADDRESS"]}/auth/Kakao";
  Uri uri = Uri.parse(apiUri);

  Future<bool> kakao(email, nickname,authority) async {
    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'nickname': nickname,
          'authority' : authority
        }),
      );
      print(response);
      if (response.statusCode == 200) {
        return response.statusCode == 200;
      } else {
        throw Exception(
            "Failed to load news. Status code: ${response.statusCode}");
      }
      // 응답 처리
    } catch (e) {
      print('Error details: $e');
      return false;
      // 에러 처리
    }
  }
}
