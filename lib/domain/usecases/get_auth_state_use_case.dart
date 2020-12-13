import 'package:cross_platform/domain/models/auth_state.dart';
import 'package:cross_platform/domain/repositories/user_repository.dart';

class GetAuthStateUseCase {
  final UserRepository _userRepository;

  const GetAuthStateUseCase(this._userRepository);

  Future<AuthenticationState> call() => _userRepository.authenticationState;
}
