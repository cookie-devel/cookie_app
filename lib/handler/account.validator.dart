final RegExp IDPW_REGEX = RegExp(r'^[a-zA-Z0-9!@#\$&*~-]+$');

const MIN_ID_LENGTH = 6;
const MAX_ID_LENGTH = 30;

bool isValidID(id) {
  return id.length >= MIN_ID_LENGTH &&
      id.length <= MAX_ID_LENGTH &&
      IDPW_REGEX.hasMatch(id);
}

const MIN_PW_LENGTH = 10;
const MAX_PW_LENGTH = 30;

bool isValidPW(pw) {
  return pw.length >= MIN_PW_LENGTH &&
      pw.length <= MAX_PW_LENGTH &&
      IDPW_REGEX.hasMatch(pw);
}

bool isValidPWCheck(pw, pwCheck) {
  return isValidPW(pw) && pw == pwCheck;
}

bool isValidSignIn(id, pw) {
  return isValidID(id) && isValidPW(pw);
}

bool isValidName(String name) {
  return name.isNotEmpty;
}

bool isValidSignUp(
  String id,
  String pw,
  String pwCheck,
  String name,
  String date,
  String phoneNumber,
) {
  return isValidID(id) && isValidPW(pw) && pw == pwCheck && isValidName(name);
}
