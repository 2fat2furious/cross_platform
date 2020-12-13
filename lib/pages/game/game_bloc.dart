import 'dart:async';
import 'dart:io';

import 'package:disposebag/disposebag.dart';
import 'package:distinct_value_connectable_stream/distinct_value_connectable_stream.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:meta/meta.dart';
import 'package:cross_platform/domain/models/auth_state.dart';
import 'package:cross_platform/domain/usecases/get_auth_state_stream_use_case.dart';
import 'package:cross_platform/utils/type_defs.dart';
import 'package:rxdart/rxdart.dart';

//ignore_for_file: close_sinks

/// BLoC that handles user profile and logout
class GameBloc extends DisposeCallbackBaseBloc {
  /// Input functions

  /// Output stream
  final DistinctValueStream<AuthenticationState> authState$;

  GameBloc._({
    @required this.authState$,
    @required Function0<void> dispose,
  }) : super(dispose);

  factory GameBloc(
      final GetAuthStateStreamUseCase getAuthState,
      ) {
    assert(getAuthState != null);


    final authenticationState$ = getAuthState();


    final authState$ = authenticationState$.publishValueDistinct(null);

    return GameBloc._(
      authState$: authState$,
      dispose: DisposeBag([
        authState$.connect(),
      ]).dispose,
    );
  }
}
