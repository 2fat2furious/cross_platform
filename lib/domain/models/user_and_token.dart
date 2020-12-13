import 'package:built_value/built_value.dart';
import 'package:cross_platform/domain/models/user.dart';
import 'package:cross_platform/domain/models/user.dart';

part 'user_and_token.g.dart';

abstract class UserAndToken
    implements Built<UserAndToken, UserAndTokenBuilder> {
  String get token;

  User get user;

  UserAndToken._();

  factory UserAndToken([void Function(UserAndTokenBuilder) updates]) =
      _$UserAndToken;
}
