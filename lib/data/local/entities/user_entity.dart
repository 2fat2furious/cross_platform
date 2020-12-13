import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cross_platform/data/serializers.dart';

part 'user_entity.g.dart';

abstract class UserEntity implements Built<UserEntity, UserEntityBuilder> {

  @BuiltValueField(wireName: 'login')
  String get login;

  static Serializer<UserEntity> get serializer => _$userEntitySerializer;

  UserEntity._();

  factory UserEntity([void Function(UserEntityBuilder) updates]) = _$UserEntity;

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      serializers.deserializeWith<UserEntity>(serializer, json);

  Map<String, dynamic> toJson() => serializers.serializeWith(serializer, this);
}
