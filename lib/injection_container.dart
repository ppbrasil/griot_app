import 'package:get_it/get_it.dart';
import 'package:griot_app/authentication/data/data_sources/auth_data_source.dart';
import 'package:griot_app/authentication/data/repositories/auth_repository_impl.dart';
import 'package:griot_app/authentication/domain/repositories/auth_repository.dart';
import 'package:griot_app/authentication/domain/usecases/perform_login.dart';
import 'package:griot_app/authentication/presentation/bloc/auth_bloc.dart';
import 'package:griot_app/core/network/network_info.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

void init() {
  // ## Features ##

  // Bloc
  sl.registerFactory(() => AuthBloc(performLogin: sl()));

  // Use Cases
  sl.registerLazySingleton(() => PerformLogin(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
      ));

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(
        client: sl(),
      ));

  // Core stuff
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External Dependencies
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());
}
