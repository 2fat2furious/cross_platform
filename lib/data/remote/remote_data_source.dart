import 'dart:io';

import 'package:cross_platform/data/remote/response/token_response.dart';
import 'package:cross_platform/data/remote/response/user_response.dart';

abstract class RemoteDataSource {
  Future<TokenResponse> loginUser(String login, String password);

  Future<TokenResponse> registerUser(
    String login,
    String password,
  );

  Future<TokenResponse> changePassword(
    String login,
    String password,
    String newPassword,
    String token,
  );

  Future<TokenResponse> resetPassword(
    String login, {
    String token,
    String newPassword,
  });

  Future<UserResponse> getUserProfile(String login, String token);

  Future<UserResponse> uploadImage(File file, String login);
}
