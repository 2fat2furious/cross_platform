import 'package:disposebag/disposebag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:cross_platform/app.dart';
import 'package:cross_platform/data/local/local_data_source.dart';
import 'package:cross_platform/data/local/shared_pref_util.dart';
import 'package:cross_platform/data/remote/api_service.dart';
import 'package:cross_platform/data/remote/remote_data_source.dart';
import 'package:cross_platform/data/user_repository_imp.dart';
import 'package:cross_platform/domain/repositories/user_repository.dart';
import 'package:cross_platform/domain/usecases/change_password_use_case.dart';
import 'package:cross_platform/domain/usecases/get_auth_state_stream_use_case.dart';
import 'package:cross_platform/domain/usecases/get_auth_state_use_case.dart';
import 'package:cross_platform/domain/usecases/login_use_case.dart';
import 'package:cross_platform/domain/usecases/logout_use_case.dart';
import 'package:cross_platform/domain/usecases/register_use_case.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DisposeBag.logger = null;


  // construct RemoteDataSource
  const RemoteDataSource remoteDataSource = ApiService();

  // construct LocalDataSource
  RxSharedPreferencesConfigs.logger = null;
  final rxPrefs = RxSharedPreferences.getInstance();
  final LocalDataSource localDataSource = SharedPrefUtil(rxPrefs);

  // construct UserRepository
  final UserRepository userRepository = UserRepositoryImpl(
    remoteDataSource,
    localDataSource,
  );

  runApp(
    Providers(
      providers: [
        Provider<LoginUseCase>(value: LoginUseCase(userRepository)),
        Provider<RegisterUseCase>(value: RegisterUseCase(userRepository)),
        Provider<LogoutUseCase>(value: LogoutUseCase(userRepository)),
        Provider<GetAuthStateStreamUseCase>(
          value: GetAuthStateStreamUseCase(userRepository),
        ),
        Provider<GetAuthStateUseCase>(
          value: GetAuthStateUseCase(userRepository),
        ),
        Provider<ChangePasswordUseCase>(
          value: ChangePasswordUseCase(userRepository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
