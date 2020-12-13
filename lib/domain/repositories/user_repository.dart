import 'dart:io';

import 'package:meta/meta.dart';
import 'package:cross_platform/domain/models/auth_state.dart';
import 'package:cross_platform/utils/result.dart';

abstract class UserRepository {
  Stream<AuthenticationState> get authenticationState$;

  Future<AuthenticationState> get authenticationState;

  Stream<Result<void>> login({
    @required String login,
    @required String password,
  });

  Stream<Result<void>> registerUser({
    @required String login,
    @required String password,
  });

  Stream<Result<void>> logout();

  Stream<Result<void>> changePassword({
    @required String password,
    @required String newPassword,
  });

}
