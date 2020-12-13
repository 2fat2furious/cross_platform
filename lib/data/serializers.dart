import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:cross_platform/data/remote/response/token_response.dart';
import 'package:cross_platform/data/remote/response/user_response.dart';
import 'package:cross_platform/data/local/entities/user_and_token_entity.dart';
import 'package:cross_platform/data/local/entities/user_entity.dart';
import 'package:cross_platform/data/remote/response/token_response.dart';
import 'package:cross_platform/data/remote/response/user_response.dart';

part 'serializers.g.dart';

@SerializersFor([
  UserEntity,
  UserAndTokenEntity,
  UserResponse,
  TokenResponse,
])
final Serializers _serializers = _$_serializers;
final serializers = (_serializers.toBuilder()
      ..add(Iso8601DateTimeSerializer())
      ..addPlugin(StandardJsonPlugin()))
    .build();
