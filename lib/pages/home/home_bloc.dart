import 'dart:async';
import 'dart:io';

import 'package:disposebag/disposebag.dart';
import 'package:distinct_value_connectable_stream/distinct_value_connectable_stream.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:meta/meta.dart';
import 'package:cross_platform/domain/models/auth_state.dart';
import 'package:cross_platform/domain/usecases/get_auth_state_stream_use_case.dart';
import 'package:cross_platform/domain/usecases/logout_use_case.dart';
import 'package:cross_platform/pages/home/home_state.dart';
import 'package:cross_platform/utils/result.dart';
import 'package:cross_platform/utils/type_defs.dart';
import 'package:rxdart/rxdart.dart';

//ignore_for_file: close_sinks

/// BLoC that handles user profile and logout
class HomeBloc extends DisposeCallbackBaseBloc {
  /// Input functions
  final Function1<File, void> changeAvatar;
  final Function0<void> logout;

  /// Output stream
  final DistinctValueStream<AuthenticationState> authState$;
  final Stream<HomeMessage> message$;

  HomeBloc._({
    @required this.changeAvatar,
    @required this.message$,
    @required this.logout,
    @required this.authState$,
    @required Function0<void> dispose,
  }) : super(dispose);

  factory HomeBloc(
    final LogoutUseCase logout,
    final GetAuthStateStreamUseCase getAuthState,
  ) {
    assert(logout != null);
    assert(getAuthState != null);

    final changeAvatarS = PublishSubject<File>();
    final logoutS = PublishSubject<void>();

    final authenticationState$ = getAuthState();

    final logoutMessage$ = Rx.merge([
      logoutS.exhaustMap((_) => logout.call()).map(_resultToLogoutMessage),
      authenticationState$
          .where((state) => state.userAndToken == null)
          .map((_) => const LogoutSuccessMessage()),
    ]);


    final authState$ = authenticationState$.publishValueDistinct(null);

    final message$ = Rx.merge([logoutMessage$]).publish();

    return HomeBloc._(
      changeAvatar: changeAvatarS.add,
      logout: () => logoutS.add(true),
      authState$: authState$,
      dispose: DisposeBag([
        authState$.connect(),
        message$.connect(),
        changeAvatarS,
        logoutS,
      ]).dispose,
      message$: message$,
    );
  }

  static LogoutMessage _resultToLogoutMessage(result) {
    if (result is Success) {
      return const LogoutSuccessMessage();
    }
    if (result is Failure) {
      return LogoutErrorMessage(result.message, result.error);
    }
    return null;
  }

  static UpdateAvatarMessage _resultToChangeAvatarMessage(result) {
    if (result is Success) {
      return const UpdateAvatarSuccessMessage();
    }
    if (result is Failure) {
      return UpdateAvatarErrorMessage(result.message, result.error);
    }
    return null;
  }
}
