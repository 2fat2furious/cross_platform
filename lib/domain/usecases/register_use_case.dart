import 'package:meta/meta.dart';
import 'package:cross_platform/domain/repositories/user_repository.dart';
import 'package:cross_platform/utils/result.dart';

class RegisterUseCase {
  final UserRepository _userRepository;

  const RegisterUseCase(this._userRepository);

  Stream<Result<void>> call({
    @required String login,
    @required String password,
  }) =>
      _userRepository.registerUser(
        login: login,
        password: password,
      );
}
