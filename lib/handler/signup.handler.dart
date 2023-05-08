import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cookie_app/components/auth/validator.dart';

// jsondata to server
Future<bool> handleSignUp({
  required String id,
  required String pw,
  required String name,
  required String birthday,
  required String phoneNumber,
  Map<String, dynamic>? profile,
}) async {
  assert(validateID(id) == null);
  assert(validatePW(pw) == null);
  assert(validateName(name) == null);
  assert(validateBirthday(birthday) == null);
  assert(validatePhoneNumber(phoneNumber) == null);

  String data = createJsonData(id, pw, name, birthday, phoneNumber);
  Map<String, dynamic> resSignUp = await multipartPostSignUp({
    "userid": id,
    "password": pw,
    "username": name,
    "birthday": birthday,
    "phone": phoneNumber,
    "profile": {"image": null, "message": null}
  }, profile);
  return resSignUp.containsKey('success') && resSignUp['success'] == true;
}

Future<Map<String, dynamic>> postSignUp(String data) async {
  String address = '${dotenv.env['BASE_URI']}/account/signup';
  try {
    Response res = await post(
      Uri.parse(address),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: data,
    );
    return json.decode(res.body);
  } catch (e) {
    print('Error sending data to server: $e');
    return {'error': 'Error sending data to server'};
  }
}

Future multipartPostSignUp(data, profile) async {
  String address = '${dotenv.env['BASE_URI']}/account/signup';

  try {
    MultipartRequest request = MultipartRequest('POST', Uri.parse(address));
    print(profile);

    request.fields['userid'] = data['userid'];
    request.fields['password'] = data['password'];
    request.fields['username'] = data['username'];
    request.fields['birthday'] = data['birthday'];
    request.fields['phone'] = data['phone'];
    request.files.add(await MultipartFile.fromPath(
      'profile_image',
      profile['image'].path,
    ));

    StreamedResponse res = await request.send();
    final body = await res.stream.bytesToString();
    print(body);
    return json.decode(body);
  } catch (e) {
    print('Error sending data to server: $e');
    return {'error': 'Error sending data to server'};
  }
}

// creadte json structure
String createJsonData(
  String id,
  String pw,
  String name,
  String date,
  String phoneNumber,
) {
  Map<String, dynamic> data = {
    "userid": id,
    "password": pw,
    "username": name,
    "birthday": date,
    "phone": phoneNumber,
    "profile": {"image": null, "message": null}
  };

  String jsonData = const JsonEncoder.withIndent('\t').convert(data);

  return jsonData;
}
