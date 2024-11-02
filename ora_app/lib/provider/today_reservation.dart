import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

class TodayReservation {
  static String apiUri =
      "${dotenv.env["NODE_BACKEND_ADDRESS"]}/company/today_reservation";
  Uri uri = Uri.parse(apiUri);
  Future<Map<String, dynamic>> today_reservation(email) async {
    print(email);
    final response = await http.post(uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
        }));
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception(
          'Failed to load news. Status code: ${response.statusCode}');
    }
  }
}
