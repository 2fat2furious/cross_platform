// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<UserResponse> _$userResponseSerializer =
    new _$UserResponseSerializer();

class _$UserResponseSerializer implements StructuredSerializer<UserResponse> {
  @override
  final Iterable<Type> types = const [UserResponse, _$UserResponse];
  @override
  final String wireName = 'UserResponse';

  @override
  Iterable<Object> serialize(Serializers serializers, UserResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'login',
      serializers.serialize(object.login,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  UserResponse deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new UserResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'login':
          result.login = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'created_at':
      }
    }

    return result.build();
  }
}

class _$UserResponse extends UserResponse {
  @override
  final String login;

  factory _$UserResponse([void Function(UserResponseBuilder) updates]) =>
      (new UserResponseBuilder()..update(updates)).build();

  _$UserResponse._({this.login})
      : super._() {
    if (login == null) {
      throw new BuiltValueNullFieldError('UserResponse', 'login');
    }
  }

  @override
  UserResponse rebuild(void Function(UserResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserResponseBuilder toBuilder() => new UserResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserResponse &&
        login == other.login;
  }


  @override
  String toString() {
    return (newBuiltValueToStringHelper('UserResponse')
          ..add('login', login))
        .toString();
  }
}

class UserResponseBuilder
    implements Builder<UserResponse, UserResponseBuilder> {
  _$UserResponse _$v;


  String _login;
  String get login => _$this._login;
  set login(String login) => _$this._login = login;

  UserResponseBuilder();

  UserResponseBuilder get _$this {
    if (_$v != null) {
      _login = _$v.login;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserResponse other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$UserResponse;
  }

  @override
  void update(void Function(UserResponseBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$UserResponse build() {
    final _$result = _$v ??
        new _$UserResponse._(login: login);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
