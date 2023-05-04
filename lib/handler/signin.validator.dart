final RegExp IDPW_REGEX = RegExp(r'^[a-zA-Z0-9!@#\$&*~-]+$');

const MIN_ID_LENGTH = 6;
const MAX_ID_LENGTH = 30;

bool idLengthCheck(id) {
  return id.length >= MIN_ID_LENGTH && id.length <= MAX_ID_LENGTH;
}

bool isValidID(id) {
  return idLengthCheck(id) && IDPW_REGEX.hasMatch(id);
}

const MIN_PW_LENGTH = 10;
const MAX_PW_LENGTH = 30;

bool pwLengthCheck(pw) {
  return pw.length >= MIN_PW_LENGTH && pw.length <= MAX_PW_LENGTH;
}

bool isValidPW(pw) {
  return pwLengthCheck(pw) && IDPW_REGEX.hasMatch(pw);
}

bool isValid(id, pw) {
  return isValidID(id) && isValidPW(pw);
}
