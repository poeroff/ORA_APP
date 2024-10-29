import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

class ChatApi {
  static String apiUri =
      "${dotenv.env["PYTHON_BACKEND_ADDRESS"]}/start_program";

  Uri uri = Uri.parse(apiUri);

  Future<Map<String, dynamic>> getmessage(userInput, currentAddress) async {
    final response = await http.post(uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": userInput, "address": currentAddress}));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception(
          "Failed to load news. Status code: ${response.statusCode}");
    }
  }
}
