import 'dart:convert';
import 'package:cookie_app/model/api/account/exists.dart';
import 'package:cookie_app/model/api/error.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

Future<ExistsResponse> apiGetExistance(String? userid, String? phone) async {
  final uri = Uri.https(dotenv.env['BASE_URI']!, '/account/exists', {
    'userid': userid,
    'phone': phone,
  });

  Response res = await get(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (res.statusCode != 200) {
    throw ErrorResponse.fromJson(json.decode(res.body));
  }

  return ExistsResponse.fromJson(json.decode(res.body));
}
