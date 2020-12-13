import 'package:built_value/built_value.dart';

part 'user.g.dart';

abstract class User implements Built<User, UserBuilder> {

  String get login;

  User._();

  factory User([void Function(UserBuilder) updates]) = _$User;
}
