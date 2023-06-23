import 'package:get_it/get_it.dart';
import 'package:griot_app/accounts/data/data_sources/accounts_remote_data_source.dart';
import 'package:griot_app/accounts/data/repository_impl/accounts_repository_impl.dart';
import 'package:griot_app/accounts/domain/repositories/accounts_repository.dart';
import 'package:griot_app/accounts/domain/use_cases/get_account_details_usecase.dart';
import 'package:griot_app/accounts/domain/use_cases/get_beloved_ones_list_use_case.dart';
import 'package:griot_app/accounts/presentation/bloc/beloved_ones_bloc_bloc.dart';
import 'package:griot_app/authentication/data/data_sources/auth_data_source.dart';
import 'package:griot_app/authentication/data/repositories/auth_repository_impl.dart';
import 'package:griot_app/authentication/domain/repositories/auth_repository.dart';
import 'package:griot_app/authentication/domain/usecases/perform_login.dart';
import 'package:griot_app/authentication/presentation/bloc/auth_bloc.dart';
import 'package:griot_app/core/data/main_account_id_provider.dart';
import 'package:griot_app/core/data/media_service.dart';
import 'package:griot_app/core/data/token_provider.dart';
import 'package:griot_app/core/network/network_info.dart';
import 'package:griot_app/memories/data/data_source/memories_local_data_source.dart';
import 'package:griot_app/memories/data/data_source/memories_remote_data_source.dart';
import 'package:griot_app/memories/data/repositories/memories_repository_impl.dart';
import 'package:griot_app/memories/domain/repositories/memories_repository.dart';
import 'package:griot_app/memories/domain/usecases/add_video_from_library_to_memory_usecase.dart';
import 'package:griot_app/memories/domain/usecases/create_memory_usecase.dart';
import 'package:griot_app/memories/domain/usecases/get_memories_list.dart';
import 'package:griot_app/memories/domain/usecases/get_memory_details_usecase.dart';
import 'package:griot_app/memories/presentation/bloc/memories_bloc_bloc.dart';
import 'package:griot_app/memories/presentation/bloc/memory_manipulation_bloc_bloc.dart';
import 'package:griot_app/profile/data/data_sources/profiles_remote_data_source.dart';
import 'package:griot_app/profile/data/repository_impl/profiles_respository_impl.dart';
import 'package:griot_app/profile/domain/repositories/profile_respository.dart';
import 'package:griot_app/profile/domain/use_cases/perform_update_profile_dateils.dart';
import 'package:griot_app/profile/presentation/bloc/profile_bloc_bloc.dart';
import 'package:griot_app/user/data/data_sources/users_remote_data_source.dart';
import 'package:griot_app/user/data/repository_impl/users_repository_impl.dart';
import 'package:griot_app/user/domain/repository/users_repository.dart';
import 'package:griot_app/user/domain/use_cases/get_user_owned_accounts_list_usecase.dart';
import 'package:griot_app/user/presentation/bloc/users_bloc_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;

import 'profile/domain/use_cases/perform_get_profile_details.dart';

final sl = GetIt.instance;

void init() {
  // Init Features
  initAuth();
  initMemories();
  initProfile();
  initUser();
  initAccounts();

  // Core stuff
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  sl.registerLazySingleton<MainAccountIdProvider>(
      () => MainAccountIdProviderImpl());
  sl.registerLazySingleton<TokenProvider>(() => TokenProviderImpl());
  sl.registerLazySingleton<MediaService>(
      () => MediaServiceImpl(imagePicker: sl()));

  // External Dependencies
  sl.registerLazySingleton<ImagePicker>(() => ImagePicker());
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
  sl.registerFactory(() => MemoriesBlocBloc(
        getMemory: sl(),
        getMemories: sl(),
      ));
  sl.registerFactory(() => MemoryManipulationBlocBloc(
        createMemory: sl(),
        accountIdProvider: sl(),
        addVideos: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton(() => CreateMemoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetMemoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetMemoriesList(sl()));
  sl.registerLazySingleton(() => AddVideoFromLibraryToMemoryUseCase(sl()));

  // Repository
  sl.registerLazySingleton<MemoriesRepository>(() => MemoriesRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
        localDataSource: sl(),
      ));

  // Data Sources
  sl.registerLazySingleton<MemoriesRemoteDataSource>(
      () => MemoriesRemoteDataSourceImpl(
            client: sl(),
            tokenProvider: sl(),
          ));

  sl.registerLazySingleton<MemoriesLocalDataSource>(
      () => MemoriesLocalDataSourceImpl(
            mediaService: sl(),
          ));
}

void initProfile() {
  // Bloc
  sl.registerFactory(
      () => ProfileBlocBloc(getDetails: sl(), updateDetails: sl()));

  // Use Cases
  sl.registerLazySingleton(() => PerformGetProfileDetails(sl()));
  sl.registerLazySingleton(() => PerformUpdateProfileDetails(sl()));

  // Repository
  sl.registerLazySingleton<ProfilesRepository>(() => ProfilesRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
      ));

  // Data Sources
  sl.registerLazySingleton<ProfilesRemoteDataSource>(
      () => ProfilesRemoteDataSourceImpl(
            client: sl(),
            tokenProvider: sl(),
          ));
}

void initUser() {
  // Bloc
  sl.registerFactory(() => UsersBlocBloc(getOwnedAccounts: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetOwnedAccountsListUseCase(sl()));

  // Repository
  sl.registerLazySingleton<UsersRepository>(() => UsersRepositoryImpl(
        networkInfo: sl(),
        remoteDataSource: sl(),
      ));

  // Data Sources
  sl.registerLazySingleton<UsersRemoteDataSource>(
      () => UsersRemoteDataSourceImpl(
            client: sl(),
            tokenProvider: sl(),
          ));
}

void initAccounts() {
  // Bloc
  sl.registerFactory(() => BelovedOnesBlocBloc(
        getBelovedOnesList: sl(),
        mainsAccountIdProvider: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton(() => GetAccountDetailsUseCase(sl()));
  sl.registerLazySingleton(() => GetBelovedOnesListUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AccountsRepository>(() => AccountsRepositoryImpl(
        networkInfo: sl(),
        remoteDataSource: sl(),
      ));

  // Data Sources
  sl.registerLazySingleton<AccountsRemoteDataSource>(
      () => AccountsRemoteDataSourceImpl(
            client: sl(),
            tokenProvider: sl(),
          ));
}
