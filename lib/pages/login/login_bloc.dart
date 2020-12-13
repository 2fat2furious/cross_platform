import 'dart:async';

import 'package:disposebag/disposebag.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:meta/meta.dart';
import 'package:cross_platform/domain/usecases/login_use_case.dart';
import 'package:cross_platform/pages/login/login.dart';
import 'package:cross_platform/utils/result.dart';
import 'package:cross_platform/utils/streams.dart';
import 'package:cross_platform/utils/type_defs.dart';
import 'package:cross_platform/utils/validators.dart';
import 'package:rxdart/rxdart.dart';

// ignore_for_file: close_sinks

/// BLoC that handles validating form and login
class LoginBloc extends DisposeCallbackBaseBloc {
  /// Input functions
  final Function1<String, void> loginChanged;
  final Function1<String, void> passwordChanged;
  final Function0<void> submitLogin;

  /// Streams
  final Stream<String> loginError$;
  final Stream<String> passwordError$;
  final Stream<LoginMessage> message$;
  final Stream<bool> isLoading$;

  LoginBloc._({
    @required Function0<void> dispose,
    @required this.loginChanged,
    @required this.passwordChanged,
    @required this.submitLogin,
    @required this.loginError$,
    @required this.passwordError$,
    @required this.message$,
    @required this.isLoading$,
  }) : super(dispose);

  factory LoginBloc(final LoginUseCase login) {
    assert(login != null);

    /// Controllers
    final loginController = PublishSubject<String>();
    final passwordController = PublishSubject<String>();
    final submitLoginController = PublishSubject<void>();
    final isLoadingController = BehaviorSubject<bool>.seeded(false);
    final controllers = [
      loginController,
      passwordController,
      submitLoginController,
      isLoadingController,
    ];

    ///
    /// Streams
    ///

    final isValidSubmit$ = Rx.combineLatest3(
      loginController.stream.map(Validator.isValid),
      passwordController.stream.map(Validator.isValid),
      isLoadingController.stream,
      (isValidEmail, isValidPassword, isLoading) =>
          isValidEmail && isValidPassword && !isLoading,
    ).shareValueSeeded(false);

    final credential$ = Rx.combineLatest2(
      loginController.stream,
      passwordController.stream,
      (login, password) => Credential(login: login, password: password),
    );

    final submit$ = submitLoginController.stream
        .withLatestFrom(isValidSubmit$, (_, bool isValid) => isValid)
        .share();

    final message$ = Rx.merge([
      submit$
          .where((isValid) => isValid)
          .withLatestFrom(credential$, (_, Credential c) => c)
          .exhaustMap(
            (credential) => login(
              login: credential.login,
              password: credential.password,
            )
                .doOnListen(() => isLoadingController.add(true))
                .doOnData((_) => isLoadingController.add(false))
                .map(_responseToMessage),
          ),
      submit$
          .where((isValid) => !isValid)
          .map((_) => const InvalidInformationMessage())
    ]).share();

    final loginError$ = loginController.stream
        .map((login) {
          if (Validator.isValid(login)) return null;
          return 'Invalid login';
        })
        .distinct()
        .share();

    final passwordError$ = passwordController.stream
        .map((password) {
          if (Validator.isValid(password)) return null;
          return 'Password must be at least 6 characters';
        })
        .distinct()
        .share();

    final subscriptions = <String, Stream>{
      'loginError': loginError$,
      'passwordError': passwordError$,
      'isValidSubmit': isValidSubmit$,
      'message': message$,
      'isLoading': isLoadingController,
    }.debug();

    return LoginBloc._(
      dispose: DisposeBag([...controllers, ...subscriptions]).dispose,
      loginChanged: trim.pipe(loginController.add),
      passwordChanged: passwordController.add,
      submitLogin: () => submitLoginController.add(null),
      loginError$: loginError$,
      passwordError$: passwordError$,
      message$: message$,
      isLoading$: isLoadingController,
    );
  }

  static LoginMessage _responseToMessage(Result result) {
    if (result is Success) {
      return const LoginSuccessMessage();
    }
    if (result is Failure) {
      return LoginErrorMessage(result.message, result.error);
    }
    return LoginErrorMessage('Unknown result $result');
  }
}
