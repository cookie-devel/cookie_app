import 'dart:convert';

import 'package:cookie_app/handler/storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> apiGetFriends() async {
  String token = await secureStorage.read(key: 'access_token') ?? '';
  try {
    String address = '${dotenv.env['BASE_URI']}/friends';
    http.Response res = await http.get(
      Uri.parse(address),
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
