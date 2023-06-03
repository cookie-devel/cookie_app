import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

Future<bool> apiPostSignUp(data, profile) async {
  final uri = Uri.https(dotenv.env['BASE_URI']!, '/account/signup');

  MultipartRequest request = MultipartRequest('POST', uri);

  request.fields['userid'] = data['userid'];
  request.fields['password'] = data['password'];
  request.fields['username'] = data['username'];
  request.fields['birthday'] = data['birthday'];
  request.fields['phone'] = data['phone'];
  request.files.add(
    await MultipartFile.fromPath(
      'profile_image',
      profile['image'].path,
    ),
  );

  StreamedResponse res = await request.send();
  final body = await res.stream.bytesToString();

  if (res.statusCode != 201) {
    throw json.decode(body);
  }

  return true;
}
