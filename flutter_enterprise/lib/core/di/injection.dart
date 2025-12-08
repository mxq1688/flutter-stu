import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../../data/datasources/remote/api_client.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/router/app_router.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // 网络
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(
      baseUrl: ApiConstants.apiBaseUrl,
      connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    return dio;
  });

  // API Client
  getIt.registerLazySingleton<ApiClient>(() => ApiClient(getIt<Dio>()));

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<ApiClient>()),
  );

  // Use Cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));

  // Blocs
  getIt.registerFactory(() => AuthBloc(
        loginUseCase: getIt<LoginUseCase>(),
        logoutUseCase: getIt<LogoutUseCase>(),
      ));

  // Router
  getIt.registerLazySingleton(() => AppRouter());
}


