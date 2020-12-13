class Validator {
  Validator._();

  static bool isValid(String password) {
    return password.length >= 1;
  }
}
