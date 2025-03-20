import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mvvm/presentation/login/bloc/login_bloc.dart';
import 'package:mvvm/presentation/login/screens/login_screen.dart';

import 'core/api_interceptor.dart';
import 'data/datasources/remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/login_usecase.dart';

final sl = GetIt.instance; // sl == service locator

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dio = Dio(); // Create Dio instance
  dio.options.headers['Content-Type'] = 'application/json';
  dio.interceptors.addAll([
    ApiInterceptors(),
    LogInterceptor(),
    InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        // Print the token
        if (kDebugMode) {
          print('Token: ${options.headers['Authorization']}');
        }

        // Proceed with the request
        handler.next(options);
      },
    )
  ]);
  sl.registerLazySingleton(() => dio);
  // Data
  sl.registerLazySingleton(() => ApiClient(sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // Domain
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // Presentation
  sl.registerFactory(() => LoginBloc(sl()));
}

void main() async {

  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login MVVM Bloc GetIt',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}