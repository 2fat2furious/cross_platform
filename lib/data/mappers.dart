part of 'user_repository_imp.dart';

abstract class _Mappers {
  /// Entity -> Domain
  static AuthenticationState userAndTokenEntityToDomainAuthState(
      UserAndTokenEntity entity) {
    if (entity == null) {
      return UnauthenticatedState();
    }

    final userAndTokenBuilder = UserAndTokenBuilder()
      ..user = _Mappers.userEntityToUserDomain(entity.user)
      ..token = entity.token;

    return AuthenticatedState((b) => b.userAndToken = userAndTokenBuilder);
  }

  /// Entity -> Domain
  static UserBuilder userEntityToUserDomain(UserEntity userEntity) {
    return UserBuilder()
      ..login = userEntity.login;
  }

  /// Response -> Entity
  static UserEntityBuilder userResponseToUserEntity(UserResponse userResponse) {
    return UserEntityBuilder()
      ..login = userResponse.login;
  }

  /// Response -> Entity
  static UserAndTokenEntity userResponseToUserAndTokenEntity(
    UserResponse user,
    String token,
  ) {
    return UserAndTokenEntity(
      (b) => b
        ..token = token
        ..user = userResponseToUserEntity(user),
    );
  }
}
