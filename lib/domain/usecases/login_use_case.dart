import 'package:meta/meta.dart';
import 'package:cross_platform/domain/repositories/user_repository.dart';
import 'package:cross_platform/utils/result.dart';

class LoginUseCase {
  final UserRepository _userRepository;

  const LoginUseCase(this._userRepository);

  Stream<Result<void>> call({
    @required String login,
    @required String password,
  }) =>
      _userRepository.login(login: login, password: password);
}
