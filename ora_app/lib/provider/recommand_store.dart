import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

class RecommandStore {
  Future<String> recommand_store(id, email) async {
    String apiUri = "${dotenv.env["NODE_BACKEND_ADDRESS"]}/company/$id";
    Uri uri = Uri.parse(apiUri);
    print(id);

    print(email);

    return "HELLO";
  }
}
