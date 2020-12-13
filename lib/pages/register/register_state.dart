import 'package:meta/meta.dart';

@immutable
class RegisterUser {
  final String login;
  final String password;

  const RegisterUser(this.login, this.password);
}

@immutable
abstract class RegisterMessage {}

class RegisterInvalidInformationMessage implements RegisterMessage {
  const RegisterInvalidInformationMessage();
}

class RegisterErrorMessage implements RegisterMessage {
  final String message;
  final Object error;

  const RegisterErrorMessage(this.message, [this.error]);
}

class RegisterSuccessMessage implements RegisterMessage {
  final String login;

  const RegisterSuccessMessage(this.login);
}
