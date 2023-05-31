import 'dart:convert';
import 'package:cookie_app/utils/jwt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

Future<Map<String, dynamic>> apiGetFriends() async {
  String token = (await JWT.read())!;
  final uri = Uri.https(dotenv.env['BASE_URI']!, '/friends');
  try {
    Response res = await get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': 'Bearer $token'
      },
    );
    return json.decode(res.body);
  } catch (e) {
    print('Error getting data from server: $e');
    return {};
  }
}
