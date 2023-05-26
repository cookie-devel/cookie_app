import 'package:cookie_app/api/account/signin.dart';
import 'package:cookie_app/components/auth/validator.dart';
import 'package:cookie_app/utils/jwt.dart';
import 'package:cookie_app/utils/myinfo.dart';

Future<bool> handleSignIn(id, pw) async {
  assert(validateID(id) == null);
  assert(validatePW(pw) == null);
  Future<Map<String, dynamic>> jsonMap = apiPostSignIn(id, pw);
  bool success = (await jsonMap).containsKey('access_token');

  if (success) {
    String token = (await jsonMap)['access_token'];
    JWT.write(token);

    Map<String, dynamic> account = (await jsonMap)['account'];
    my = Me.loadFromJSON(account);
    accountStorage.writeJSON(account);

    return true;
  } else {
    return false;
  }
}

Future<bool> handleSignOut() async {
  try {
    JWT.delete();
    accountStorage.deleteData();
    return true;
  } catch (e) {
    print('Error signing out: $e');
    return false;
  }
}
