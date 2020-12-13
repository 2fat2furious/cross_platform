import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cross_platform/data/serializers.dart';

part 'user_response.g.dart';

abstract class UserResponse
    implements Built<UserResponse, UserResponseBuilder> {

  @BuiltValueField(wireName: 'login')
  String get login;


  static Serializer<UserResponse> get serializer => _$userResponseSerializer;

  UserResponse._();

  factory UserResponse([void Function(UserResponseBuilder) updates]) =
      _$UserResponse;

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      serializers.deserializeWith<UserResponse>(serializer, json);

  Map<String, dynamic> dynamictoJson() => serializers.serializeWith(serializer, this);
}
