import 'dart:async';
import 'dart:convert' show Encoding, json;
import 'dart:io';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path/path.dart' as path;
import 'package:cross_platform/data/constants.dart';
import 'package:cross_platform/data/exception/remote_data_source_exception.dart';
import 'package:cross_platform/data/remote/network_utils.dart';
import 'package:cross_platform/data/remote/remote_data_source.dart';
import 'package:cross_platform/data/remote/response/token_response.dart';
import 'package:cross_platform/data/remote/response/user_response.dart';

class ApiService implements RemoteDataSource {
  static const String xAccessToken = 'x-access-token';

  const ApiService();

  ///
  /// Login user with [email] and [password]
  /// return [TokenResponse] including message and token
  ///
  @override
  Future<TokenResponse> loginUser(
    String login,
    String password,
  ) async {
    final url = Uri.http(baseUrl, '/users/login');
    // final credentials = '$login:$password';
    // final basic = 'Basic ${base64Encode(utf8.encode(credentials))}';
    // final json = await NetworkUtils.post(url, headers: {
    //   HttpHeaders.authorizationHeader: basic,
    // });
    final body = <String, String>{
      'login': login,
      'password': password,
    };
    final decoded = await NetworkUtils.post(url, body: body, headers: {'Content-Type': 'application/json'},encoding: Encoding.getByName('utf-8'));
    return TokenResponse.fromJson(decoded);

  }

  ///
  /// Login user with [email] and [password]
  /// return message
  ///
  @override
  Future<TokenResponse> registerUser(
    String login,
    String password,
  ) async {
    final url = Uri.http(baseUrl, '/users');
    final body = <String, String>{
      'login': login,
      'password': password,
    };
    final decoded = await NetworkUtils.post(url, body: body, headers: {'Content-Type': 'application/json'},encoding: Encoding.getByName('utf-8'));
    return TokenResponse.fromJson(decoded);
  }

  ///
  /// Get user profile by [login] and [token]
  /// return [User]
  ///
  @override
  Future<UserResponse> getUserProfile(
    String login,
    String token,
  ) async {
    final url = Uri.http(baseUrl, '/users/$login');
    final json = await NetworkUtils.get(url, headers: {xAccessToken: token});
    return UserResponse.fromJson(json);
  }

  ///
  /// Change password of user
  /// return message
  ///
  @override
  Future<TokenResponse> changePassword(
    String login,
    String password,
    String newPassword,
    String token,
  ) async {
    final url = Uri.http(baseUrl, '/users/change/$login');
    final body = {'password': password, 'newPassword': newPassword};
    final json = await NetworkUtils.put(
      url,
      headers: {'Content-Type': 'application/json', xAccessToken: token},
      body: body,
      encoding: Encoding.getByName('utf-8'),
    );
    return TokenResponse.fromJson(json);
  }

  ///
  /// Reset password
  /// Special token and newPassword to reset password,
  /// otherwise, send an email to email
  /// return message
  ///
  @override
  Future<TokenResponse> resetPassword(
    String login, {
    String token,
    String newPassword,
  }) async {
    final url = Uri.http(baseUrl, '/users/$login/password');
    final task = token != null && newPassword != null
        ? NetworkUtils.post(url, body: {
            'token': token,
            'newPassword': newPassword,
          })
        : NetworkUtils.post(url);
    final json = await task;
    return TokenResponse.fromJson(json);
  }

  ///
  /// Upload avatar image
  /// return [User] profile after image file is uploaded
  ///
  @override
  Future<UserResponse> uploadImage(
    File file,
    String login,
  ) async {
    final url = Uri.http(baseUrl, '/users/upload');
    final stream = http.ByteStream(file.openRead());
    final length = await file.length();
    final request = http.MultipartRequest('POST', url)
      ..fields['user'] = login
      ..files.add(
        http.MultipartFile(
          'my_image',
          stream,
          length,
          filename: path.basename(file.path),
        ),
      );
    final streamedResponse = await request.send();
    final statusCode = streamedResponse.statusCode;
    final decoded = json.decode(await streamedResponse.stream.bytesToString());

    debugPrint('decoded: $decoded');

    if (statusCode < 200 || statusCode >= 300) {
      throw RemoteDataSourceException(statusCode, decoded['message']);
    }

    return UserResponse.fromJson(decoded);
  }
}
