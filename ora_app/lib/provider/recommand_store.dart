import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

class RecommandStore {
  Future<String> recommand_store(id, email) async {
    String apiUri = "${dotenv.env["NODE_BACKEND_ADDRESS"]}/company/$id";
    Uri uri = Uri.parse(apiUri);
    final response = await http.post(uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
        }));
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == 409) {
        return "409";
      }
      return "200";
    } else {
      throw Exception(
          'Failed to load news. Status code: ${response.statusCode}');
    }
  }
}
