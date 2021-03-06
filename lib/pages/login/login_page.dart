import 'package:disposebag/disposebag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:cross_platform/pages/home/home.dart';
import 'package:cross_platform/pages/login/login.dart';
import 'package:cross_platform/pages/register/register.dart';
import 'package:cross_platform/utils/delay.dart';
import 'package:cross_platform/utils/snackbar.dart';
import 'package:cross_platform/widgets/password_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login_page';

  const LoginPage({Key key}) : super(key: key);

  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin<LoginPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DisposeBag disposeBag;

  AnimationController loginButtonController;
  Animation<double> buttonSqueezeAnimation;

  FocusNode passwordFocusNode;
  TextEditingController loginController;

  @override
  void initState() {
    super.initState();

    loginButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    buttonSqueezeAnimation = Tween(
      begin: 320.0,
      end: 70.0,
    ).animate(
      CurvedAnimation(
        parent: loginButtonController,
        curve: Interval(
          0.0,
          0.250,
        ),
      ),
    );

    passwordFocusNode = FocusNode();
    loginController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    disposeBag ??= () {
      final loginBloc = BlocProvider.of<LoginBloc>(context);
      return DisposeBag([
        loginBloc.message$.listen(handleMessage),
        loginBloc.isLoading$.listen((isLoading) {
          if (isLoading) {
            loginButtonController
              ..reset()
              ..forward();
          } else {
            loginButtonController.reverse();
          }
        })
      ]);
    }();
  }

  @override
  void dispose() {
    loginButtonController.dispose();
    disposeBag.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    return Scaffold(
      key: scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: MediaQuery
                  .of(context)
                  .padding
                  .top),
              color: Colors.transparent,
              width: double.infinity,
              height: kToolbarHeight,
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Image.asset(
                                'assets/logo.png',
                                width: 350,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: loginTextField(loginBloc),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: passwordTextField(loginBloc),
                      ),
                      const SizedBox(height: 32.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: loginButton(loginBloc),
                      ),
                      const SizedBox(height: 32.0),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: needAnAccount(loginBloc),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void handleMessage(message) async {
    if (message is LoginSuccessMessage) {
      scaffoldKey.showSnackBar('Успешно');
      await delay(1000);
      await Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    }
    if (message is LoginErrorMessage) {
      scaffoldKey.showSnackBar(message.message);
    }
    if (message is InvalidInformationMessage) {
      scaffoldKey.showSnackBar(AppLocalizations.of(context).messageCredentialsIncorrect);
    }
  }

  Widget loginTextField(LoginBloc loginBloc) {
    return StreamBuilder<String>(
      stream: loginBloc.loginError$,
      builder: (context, snapshot) {
        return TextField(
          controller: loginController,
          autocorrect: true,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(end: 8.0),
              child: Icon(Icons.person),
            ),
            labelText: AppLocalizations.of(context).login,
            errorText: snapshot.data,
          ),
          keyboardType: TextInputType.emailAddress,
          maxLines: 1,
          style: TextStyle(fontSize: 16.0),
          onChanged: loginBloc.loginChanged,
          textInputAction: TextInputAction.next,
          autofocus: true,
          onSubmitted: (_) {
            FocusScope.of(context).requestFocus(passwordFocusNode);
          },
        );
      },
    );
  }

  Widget passwordTextField(LoginBloc loginBloc) {
    return StreamBuilder<String>(
      stream: loginBloc.passwordError$,
      builder: (context, snapshot) {
        return PasswordTextField(
          errorText: snapshot.data,
          onChanged: loginBloc.passwordChanged,
          labelText: AppLocalizations.of(context).password,
          textInputAction: TextInputAction.done,
          onSubmitted: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          focusNode: passwordFocusNode,
        );
      },
    );
  }

  Widget loginButton(LoginBloc loginBloc) {
    return AnimatedBuilder(
      animation: buttonSqueezeAnimation,
      child: MaterialButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          loginBloc.submitLogin();
        },
        color: Theme
            .of(context)
            .backgroundColor,
        child: Text(
          AppLocalizations.of(context).aut,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        splashColor: Theme
            .of(context)
            .accentColor,
      ),
      builder: (context, child) {
        final value = buttonSqueezeAnimation.value;

        return Container(
          width: value,
          height: 60.0,
          child: Material(
            elevation: 5.0,
            clipBehavior: Clip.antiAlias,
            shadowColor: Theme
                .of(context)
                .accentColor,
            borderRadius: BorderRadius.circular(24.0),
            child: value > 75.0
                ? child
                : Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget needAnAccount(LoginBloc loginBloc) {
    return FlatButton(
      onPressed: () async {
        final login = await Navigator.pushNamed(
          context,
          RegisterPage.routeName,
        );
        print('[DEBUG] login = $login');
        if (login != null && login is String) {
          loginController.text = login;
          loginBloc.loginChanged(login);
          FocusScope.of(context).requestFocus(passwordFocusNode);
        }
      },
      child: Text(
        AppLocalizations.of(context).qLogin,
        style: TextStyle(
          color: Colors.white70,
          fontStyle: FontStyle.italic,
          fontSize: 14.0,
        ),
      ),
    );
  }
}