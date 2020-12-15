import 'package:cross_platform/pages/game/game_bloc.dart';
import 'package:cross_platform/pages/game/game_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:cross_platform/domain/models/auth_state.dart';
import 'package:cross_platform/domain/usecases/get_auth_state_stream_use_case.dart';
import 'package:cross_platform/domain/usecases/get_auth_state_use_case.dart';
import 'package:cross_platform/domain/usecases/login_use_case.dart';
import 'package:cross_platform/domain/usecases/logout_use_case.dart';
import 'package:cross_platform/domain/usecases/register_use_case.dart';
import 'package:cross_platform/pages/home/home.dart';
import 'package:cross_platform/pages/login/login.dart';
import 'package:cross_platform/pages/register/register.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cross_platform/pages/map/map_bloc.dart';
import 'package:cross_platform/pages/map/map_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routes = <String, WidgetBuilder>{
      '/': (context) => const Home(),
      RegisterPage.routeName: (context) {
        final registerUser = Provider.of<RegisterUseCase>(context);

        return BlocProvider<RegisterBloc>(
          child: const RegisterPage(),
          initBloc: () => RegisterBloc(registerUser),
        );
      },
      HomePage.routeName: (context) {
        final logout = Provider.of<LogoutUseCase>(context);
        final getAuthState = Provider.of<GetAuthStateStreamUseCase>(context);

        return BlocProvider<HomeBloc>(
          child: const HomePage(),
          initBloc: () => HomeBloc(
            logout,
            getAuthState,
          ),
        );
      },
      LoginPage.routeName: (context) {
        final login = Provider.of<LoginUseCase>(context);
        return BlocProvider<LoginBloc>(
          initBloc: () => LoginBloc(login),
          child: const LoginPage(),
        );
      },
      GamePage.routeName: (context) {
        final getAuthState = Provider.of<GetAuthStateStreamUseCase>(context);
        return BlocProvider<GameBloc>(
          initBloc: () => GameBloc(getAuthState),
          child: GamePage(),
        );
      },
      MapPage.routeName: (context) {
        final getAuthState = Provider.of<GetAuthStateStreamUseCase>(context);
        return BlocProvider<MapBloc>(
          initBloc: () => MapBloc(getAuthState),
          child: MapPage(),
        );
      },
    };

    return Provider<Map<String, WidgetBuilder>>(
      value: routes,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.dark,
          accentColor: const Color(0xFF000000),
        ),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en'),
          const Locale('ru'),
        ],
        initialRoute: '/',
        routes: routes,
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final getAuthState = Provider.of<GetAuthStateUseCase>(context);
    final routes = Provider.of<Map<String, WidgetBuilder>>(context);

    return FutureBuilder<AuthenticationState>(
      future: getAuthState(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          print('[HOME] home [1] >> [waiting...]');

          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).cardColor,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: const AlwaysStoppedAnimation(Colors.black),
              ),
            ),
          );
        }

        if (snapshot.hasError || snapshot.data is UnauthenticatedState) {
          print('[HOME] home [2] >> [NotAuthenticated]');
          return routes[LoginPage.routeName](context);
        }

        if (snapshot.data is AuthenticatedState) {
          print('[HOME] home [3] >> [Authenticated]');
          return routes[HomePage.routeName](context);
        }

        return Container(width: 0, height: 0);
      },
    );
  }
}
