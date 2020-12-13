import 'package:cross_platform/domain/models/auth_state.dart';
import 'package:cross_platform/domain/repositories/user_repository.dart';

class GetAuthStateStreamUseCase {
  final UserRepository _userRepository;

  const GetAuthStateStreamUseCase(this._userRepository);

  Stream<AuthenticationState> call() => _userRepository.authenticationState$;
}
