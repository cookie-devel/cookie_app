import 'dart:convert';
import 'package:http/http.dart';
import 'package:cookie_app/types/api/account/info.dart';
import 'package:cookie_app/types/api/account/exists.dart';
import 'package:cookie_app/types/api/error.dart';
import 'package:cookie_app/repository/jwt.repo.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AccountAPI {
  static Future<ExistsResponse> getExistance(
    String? userid,
    String? phone,
  ) async {
    final uri = Uri(
      scheme: dotenv.env['API_SCHEME'],
      host: dotenv.env['API_HOST'],
      port: int.parse(dotenv.env['API_PORT']!),
      path: '/account/exists',
      queryParameters: {
        'userid': userid,
        'phone': phone,
      },
    );

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

  static Future<InfoResponse> getInfo({List<String>? fields}) async {
    String token = (await JWTRepositoryStorageImpl().read())!;
    final uri = Uri.https(
      dotenv.env['BASE_URI']!,
      '/account/info',
      fields != null ? {"fields": fields.join(',')} : null,
    );
    Response res = await get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': 'Bearer $token'
      },
    );

    if (res.statusCode != 200) {
      throw ErrorResponse.fromJson(json.decode(res.body));
    }
    return InfoResponse.fromJson(json.decode(res.body));
  }
}
