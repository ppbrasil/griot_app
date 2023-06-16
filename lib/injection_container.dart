import 'package:get_it/get_it.dart';
import 'package:griot_app/authentication/data/data_sources/auth_data_source.dart';
import 'package:griot_app/authentication/data/repositories/auth_repository_impl.dart';
import 'package:griot_app/authentication/domain/repositories/auth_repository.dart';
import 'package:griot_app/authentication/domain/usecases/perform_login.dart';
import 'package:griot_app/authentication/presentation/bloc/auth_bloc.dart';
import 'package:griot_app/core/network/network_info.dart';
import 'package:griot_app/memories/data/data_source/memories_remote_data_source.dart';
import 'package:griot_app/memories/data/repositories/memories_repository_impl.dart';
import 'package:griot_app/memories/domain/repositories/memories_repository.dart';
import 'package:griot_app/memories/domain/usecases/create_memory_usecase.dart';
import 'package:griot_app/memories/domain/usecases/get_memories_list.dart';
import 'package:griot_app/memories/domain/usecases/get_memory_details_usecase.dart';
import 'package:griot_app/memories/presentation/bloc/memories_bloc_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

void init() {
  // Init Features
  initAuth();
  initMemories();

  // Core stuff
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External Dependencies
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());
}

void initAuth() {
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
}

void initMemories() {
  // Bloc
  sl.registerFactory(() =>
      MemoriesBlocBloc(getMemory: sl(), getMemories: sl(), createMemory: sl()));

  // Use Cases
  sl.registerLazySingleton(() => CreateMemoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetMemoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetMemoriesList(sl()));

  // Repository
  sl.registerLazySingleton<MemoriesRepository>(() => MemoriesRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
      ));

  // Data Sources
  sl.registerLazySingleton<MemoriesRemoteDataSource>(
      () => MemoriesRemoteDataSourceImpl(
            client: sl(),
          ));
}
