import 'package:cross_platform/domain/repositories/user_repository.dart';
import 'package:cross_platform/utils/result.dart';
import 'package:meta/meta.dart';

class ChangePasswordUseCase {
  final UserRepository _userRepository;

  const ChangePasswordUseCase(this._userRepository);

  Stream<Result<void>> call({
    @required String password,
    @required String newPassword,
  }) =>
      _userRepository.changePassword(
        password: password,
        newPassword: newPassword,
      );
}
