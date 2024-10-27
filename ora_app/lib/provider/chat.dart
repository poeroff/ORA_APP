import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

class ChatApi {
  static String apiUri =
      "${dotenv.env["PYTHON_BACKEND_ADDRESS"]}/start_conversation";

  Uri uri = Uri.parse(apiUri);

  Future<String> getmessage(userInput, currentAddress) async {
    print(userInput);
    print(currentAddress);
    print(uri);
    final response = await http.post(uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": userInput, "address": currentAddress}));
    if (response.statusCode == 200) {
      // JSON 응답을 파싱
      Map<String, dynamic> data = jsonDecode(response.body);
      // 'message' 키의 값을
      print(data);
      return data['message'];
    } else {
      throw Exception(
          "Failed to load news. Status code: ${response.statusCode}");
    }
  }
}
