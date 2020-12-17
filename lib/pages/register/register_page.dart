import 'package:disposebag/disposebag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:cross_platform/pages/register/register.dart';
import 'package:cross_platform/utils/delay.dart';
import 'package:cross_platform/utils/snackbar.dart';
import 'package:cross_platform/widgets/password_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = '/register_page';

  const RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DisposeBag disposeBag;

  AnimationController registerButtonController;
  Animation<double> buttonSqueezeAnimation;

  FocusNode loginFocusNode;
  FocusNode passwordFocusNode;

  @override
  void initState() {
    super.initState();

    registerButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    buttonSqueezeAnimation = Tween(
      begin: 320.0,
      end: 70.0,
    ).animate(
      CurvedAnimation(
        parent: registerButtonController,
        curve: Interval(0.0, 0.250),
      ),
    );

    loginFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    disposeBag ??= () {
      final registerBloc = BlocProvider.of<RegisterBloc>(context);
      return DisposeBag([
        registerBloc.message$.listen(handleMessage),
        registerBloc.isLoading$.listen((isLoading) {
          if (isLoading) {
            registerButtonController
              ..reset()
              ..forward();
          } else {
            registerButtonController.reverse();
          }
        }),
      ]);
    }();
  }

  @override
  void dispose() {
    disposeBag.dispose();
    registerButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registerBloc = BlocProvider.of<RegisterBloc>(context);

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
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              color: Colors.transparent,
              width: double.infinity,
              height: kToolbarHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  BackButton(color: Colors.white),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        child: loginTextField(registerBloc),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: passwordTextField(registerBloc),
                      ),
                      const SizedBox(height: 32.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: registerButton(registerBloc),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleMessage(RegisterMessage message) async {
    if (message is RegisterSuccessMessage) {
      scaffoldKey.showSnackBar('Вы успешно зарегистрированы!');
      await delay(1000);
      Navigator.pop<String>(context, message.login);
    }
    if (message is RegisterErrorMessage) {
      scaffoldKey.showSnackBar(message.message);
    }
    if (message is RegisterInvalidInformationMessage) {
      scaffoldKey.showSnackBar(AppLocalizations.of(context).validate);
    }
  }

  Widget loginTextField(RegisterBloc registerBloc) {
    return StreamBuilder<String>(
      stream: registerBloc.loginError$,
      builder: (context, snapshot) {
        return TextField(
          onChanged: registerBloc.loginChanged,
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
          focusNode: loginFocusNode,
          onSubmitted: (_) {
            FocusScope.of(context).requestFocus(passwordFocusNode);
          },
          textInputAction: TextInputAction.next,
        );
      },
    );
  }

  Widget passwordTextField(RegisterBloc registerBloc) {
    return StreamBuilder<String>(
      stream: registerBloc.passwordError$,
      builder: (context, snapshot) {
        return PasswordTextField(
          errorText: snapshot.data,
          labelText: AppLocalizations.of(context).password,
          onChanged: registerBloc.passwordChanged,
          focusNode: passwordFocusNode,
          onSubmitted: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          textInputAction: TextInputAction.done,
        );
      },
    );
  }

  Widget registerButton(RegisterBloc registerBloc) {
    return AnimatedBuilder(
      animation: buttonSqueezeAnimation,
      child: MaterialButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          registerBloc.submitRegister();
        },
        color: Theme.of(context).backgroundColor,
        child: Text(
          AppLocalizations.of(context).register,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        splashColor: Theme.of(context).accentColor,
      ),
      builder: (context, child) {
        final value = buttonSqueezeAnimation.value;

        return Container(
          width: value,
          height: 60.0,
          child: Material(
            elevation: 5.0,
            clipBehavior: Clip.antiAlias,
            shadowColor: Theme.of(context).accentColor,
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

}
