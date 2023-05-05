final RegExp IDPW_REGEX = RegExp(r'^[a-zA-Z0-9!@#\$&*~-]+$');

const MIN_ID_LENGTH = 6;
const MAX_ID_LENGTH = 30;

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

String? validatePWCheck(pw, pwCheck) {
  if (pwCheck == null || pwCheck.isEmpty) {
    return '비밀번호 확인을 입력해주세요.';
  } else if (pw != pwCheck) {
    return '비밀번호가 일치하지 않습니다.';
  } else {
    return null;
  }
}

const MAX_NAME_LENGTH = 30;

String? validateName(name) {
  if (name == null || name.isEmpty) {
    return '이름을 입력해주세요.';
  } else {
    return null;
  }
}

String? validateBirthday(birthday) {
  if (birthday == null || birthday.isEmpty) {
    return '생년월일을 입력해주세요.';
  } else {
    return null;
  }
}

String? validatePhoneNumber(phoneNumber) {
  if (phoneNumber == null || phoneNumber.isEmpty) {
    return '휴대폰 번호를 입력해주세요.';
  } else {
    return null;
  }
}
