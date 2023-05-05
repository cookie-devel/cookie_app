final RegExp IDPW_REGEX = RegExp(r'^[a-zA-Z0-9!@#\$&*~-]+$');

const MIN_ID_LENGTH = 6;
const MAX_ID_LENGTH = 30;

bool isValidID(id) {
  return id.length >= MIN_ID_LENGTH &&
      id.length <= MAX_ID_LENGTH &&
      IDPW_REGEX.hasMatch(id);
}

String? validateID(id) {
  if (id == null || id.isEmpty) {
    return '아이디를 입력해주세요.';
  } else if (id.length < MIN_ID_LENGTH) {
    return '최소 $MIN_ID_LENGTH자 이상 입력해주세요.';
  } else if (id.length > MAX_ID_LENGTH) {
    return '최대 $MAX_ID_LENGTH자 이하로 입력해주세요.';
  } else if (!IDPW_REGEX.hasMatch(id)) {
    return '영문, 숫자, 특수문자(!@#\$&*~-)만 입력해주세요.';
  } else {
    return null;
  }
}

const MIN_PW_LENGTH = 10;
const MAX_PW_LENGTH = 30;

bool isValidPW(pw) {
  return pw.length >= MIN_PW_LENGTH &&
      pw.length <= MAX_PW_LENGTH &&
      IDPW_REGEX.hasMatch(pw);
}

String? validatePW(pw) {
  if (pw == null || pw.isEmpty) {
    return '비밀번호를 입력해주세요.';
  } else if (pw.length < MIN_PW_LENGTH) {
    return '최소 $MIN_PW_LENGTH자 이상 입력해주세요.';
  } else if (pw.length > MAX_PW_LENGTH) {
    return '최대 $MAX_PW_LENGTH자 이하로 입력해주세요.';
  } else if (!IDPW_REGEX.hasMatch(pw)) {
    return '영문, 숫자, 특수문자(!@#\$&*~-)만 입력해주세요.';
  } else {
    return null;
  }
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
