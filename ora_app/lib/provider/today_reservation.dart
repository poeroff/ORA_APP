import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ora_app/model/reservation.dart';

class TodayReservation {
  static String apiUri =
      "${dotenv.env["NODE_BACKEND_ADDRESS"]}/company/today/reservation";
  Uri uri = Uri.parse(apiUri);

  Future<List<Reservation>> today_reservation(email) async {
    final response = await http.post(uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
        }));
    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Reservation.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  }
}

// Reservation 및 Company 클래스 정의는 여기에 포함되어야 합니다.