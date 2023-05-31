import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

Future<Map<String, dynamic>> apiPostSignIn(String id, String pw) async {
  final uri = Uri.https(dotenv.env['BASE_URI']!, '/account/signin');
  try {
    Response res = await post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: const JsonEncoder().convert({"userid": id, "password": pw}),
    );
    return json.decode(res.body);
  } catch (e) {
    print('Error sending data to server: $e');
    return {};
  }
}
