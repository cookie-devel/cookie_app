import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

import 'package:cookie_app/repository/jwt.repo.dart';
import 'package:cookie_app/types/api/account/info.dart';
import 'package:cookie_app/types/api/error.dart';

class AccountAPI {
  static Future<InfoResponse> getInfo({List<String>? fields}) async {
    String token = JWTRepository.token!;
    final uri = Uri(
      scheme: dotenv.env['API_SCHEME'],
      host: dotenv.env['API_HOST'],
      port: int.parse(dotenv.env['API_PORT']!),
      path: '/account/info',
    );
    Response res = await get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': 'Bearer $token',
      },
    );

    if (res.statusCode != 200) {
      throw ErrorResponse.fromJson(json.decode(res.body));
    }
    return InfoResponse.fromJson(json.decode(res.body));
  }
}
