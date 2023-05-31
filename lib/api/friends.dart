import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

Future<Map<String, dynamic>> apiGetFriends(
    String? userid, String? phone) async {
  final uri = Uri.https(dotenv.env['BASE_URI']!, '/friends', {
    'userid': userid,
    'phone': phone,
  });

  try {
    Response res = await get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return json.decode(res.body);
  } catch (e) {
    print('Error getting data from server: $e');
    return {};
  }
}
