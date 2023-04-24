import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

// 임시
Future<Map<String, dynamic>> chatRoomHandler(String data) async {
  try {
    String address = '${dotenv.env['BASE_URI']}/account/chatrooms';
    http.Response res = await http.post(
      Uri.parse(address),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: data,
    );
    return json.decode(res.body);
  } catch (e) {
    print('Error sending data to server: $e');
    return {};
  }
}