import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

Future<Map<String, dynamic>> apiGetExistance() async {
  try {
    String address = '${dotenv.env['BASE_URI']}/accoount/exists';
    Response res = await get(
      Uri.parse(address),
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
