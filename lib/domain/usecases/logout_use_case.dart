import 'package:cross_platform/domain/repositories/user_repository.dart';
import 'package:cross_platform/utils/result.dart';

class LogoutUseCase {
  final UserRepository _userRepository;

  const LogoutUseCase(this._userRepository);

  Stream<Result<void>> call() => _userRepository.logout();
}
