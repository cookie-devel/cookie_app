import 'dart:convert';
import 'package:cookie_app/model/api/error.dart';
import 'package:cookie_app/model/api/friends.dart';
import 'package:cookie_app/repository/jwt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

Future<GetFriendsResponse> apiGetFriends() async {
  String token = JWT.token!;
  final uri = Uri.https(dotenv.env['BASE_URI']!, '/friends');
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

  return GetFriendsResponse.fromJson(json.decode(res.body));
}
