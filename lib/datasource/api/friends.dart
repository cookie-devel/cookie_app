import 'dart:convert';
import 'package:cookie_app/types/api/error.dart';
import 'package:cookie_app/types/api/friends.dart';
import 'package:cookie_app/repository/jwt.repo.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

Future<GetFriendsResponse> apiGetFriends() async {
  String token = JWTRepository.token!;
  final uri = Uri(
    scheme: dotenv.env['API_SCHEME'],
    host: dotenv.env['API_HOST'],
    port: int.parse(dotenv.env['API_PORT']!),
    path: '/friends',
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

  return GetFriendsResponse.fromJson(json.decode(res.body));
}
