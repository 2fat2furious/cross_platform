import 'dart:async';

import 'package:disposebag/disposebag.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:meta/meta.dart';
import 'package:cross_platform/domain/usecases/register_use_case.dart';
import 'package:cross_platform/pages/register/register.dart';
import 'package:cross_platform/utils/result.dart';
import 'package:cross_platform/utils/streams.dart';
import 'package:cross_platform/utils/type_defs.dart';
import 'package:cross_platform/utils/validators.dart';
import 'package:rxdart/rxdart.dart';

// ignore_for_file: close_sinks

/// BLoC handles validating form and register
class RegisterBloc extends DisposeCallbackBaseBloc {
  /// Input functions
  final Function1<String, void> loginChanged;
  final Function1<String, void> passwordChanged;
  final Function0<void> submitRegister;

  /// Streams
  final Stream<String> loginError$;
  final Stream<String> passwordError$;
  final Stream<RegisterMessage> message$;
  final Stream<bool> isLoading$;

  RegisterBloc._({
    @required Function0<void> dispose,
    @required this.loginChanged,
    @required this.passwordChanged,
    @required this.submitRegister,
    @required this.loginError$,
    @required this.passwordError$,
    @required this.message$,
    @required this.isLoading$,
  }) : super(dispose);

  factory RegisterBloc(final RegisterUseCase registerUser) {
    assert(registerUser != null);

    /// Controllers
    final loginController = PublishSubject<String>();
    final nameController = PublishSubject<String>();
    final passwordController = PublishSubject<String>();
    final submitRegisterController = PublishSubject<void>();
    final isLoadingController = BehaviorSubject<bool>.seeded(false);
    final controllers = [
      loginController,
      nameController,
      passwordController,
      submitRegisterController,
      isLoadingController,
    ];

    ///
    /// Streams
    ///

    final isValidSubmit$ = Rx.combineLatest3(
      loginController.stream.map(Validator.isValid),
      passwordController.stream.map(Validator.isValid),
      isLoadingController.stream,
      (isValidLogin, isValidPassword, isLoading) {
        return isValidLogin && isValidPassword && !isLoading;
      },
    ).shareValueSeeded(false);

    final registerUser$ = Rx.combineLatest2(
      loginController.stream,
      passwordController.stream,
      (login, password) => RegisterUser(login, password),
    );

    final submit$ = submitRegisterController.stream
        .withLatestFrom(isValidSubmit$, (_, bool isValid) => isValid)
        .share();

    final message$ = Rx.merge([
      submit$
          .where((isValid) => isValid)
          .withLatestFrom(registerUser$, (_, RegisterUser user) => user)
          .exhaustMap(
            (user) => registerUser(
              login: user.login,
              password: user.password,
            )
                .doOnListen(() => isLoadingController.add(true))
                .doOnData((_) => isLoadingController.add(false))
                .map((result) => _responseToMessage(result, user.login)),
          ),
      submit$
          .where((isValid) => !isValid)
          .map((_) => const RegisterInvalidInformationMessage())
    ]).share();

    final loginError$ = loginController.stream
        .map((login) {
          if (Validator.isValid(login)) return null;
          return 'Invalid login address';
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

    return RegisterBloc._(
      dispose: DisposeBag([...subscriptions, ...controllers]).dispose,
      loginChanged: trim.pipe(loginController.add),
      passwordChanged: passwordController.add,
      submitRegister: () => submitRegisterController.add(null),
      loginError$: loginError$,
      passwordError$: passwordError$,
      message$: message$,
      isLoading$: isLoadingController,
    );
  }

  static RegisterMessage _responseToMessage(Result result, String login) {
    if (result is Success) {
      return RegisterSuccessMessage(login);
    }
    if (result is Failure) {
      return RegisterErrorMessage(result.message, result.error);
    }
    return RegisterErrorMessage('Unknown result $result');
  }
}
