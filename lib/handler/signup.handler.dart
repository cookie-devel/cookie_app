import 'dart:convert';
import 'package:cookie_app/api/account/signup.dart';
import 'package:cookie_app/view/components/auth/validator.dart';

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
  Map<String, dynamic> resSignUp = await apiPostSignUp(
    {
      "userid": id,
      "password": pw,
      "username": name,
      "birthday": birthday,
      "phone": phoneNumber,
      "profile": {"image": null, "message": null}
    },
    profile,
  );
  return resSignUp.containsKey('success') && resSignUp['success'] == true;
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
