import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:griot_app/authentication/presentation/bloc/auth_bloc_bloc.dart';
import 'package:griot_app/core/data/core_repository_impl.dart';
import 'package:griot_app/core/presentation/bloc/connectivity_bloc_bloc.dart';
import 'package:griot_app/injection_container.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core_repository_impl_test.mocks.dart';

@GenerateMocks([AuthBlocBloc, ConnectivityBlocBloc, SharedPreferences])
void main() {
  final mockSharedPreferences = MockSharedPreferences();
  final mockAuthBlocBloc = MockAuthBlocBloc();
  final mockConnectivityBlocBloc = MockConnectivityBlocBloc();
  final coreRepositoryImpl =
      CoreRepositoryImpl(sharedPreferences: mockSharedPreferences);

  group('performTokenExceptionPolicies', () {
    setUp(() {
      init();

      // Unregister the original AuthBlocBloc
      if (sl.isRegistered<AuthBlocBloc>()) {
        sl.unregister<AuthBlocBloc>();
      }

      // Register your MockAuthBlocBloc
      sl.registerLazySingleton<AuthBlocBloc>(() => mockAuthBlocBloc);

      SharedPreferences.setMockInitialValues({});
    });

    test(
        'Should add TokenFailedEvent when performTokenExceptionPolicies is called ',
        () async {
      when(mockSharedPreferences.remove('token')).thenAnswer((_) async => true);
      await coreRepositoryImpl.performTokenExceptionPolicies();

      verify(mockAuthBlocBloc.add(TokenFailedEvent())).called(1);
    });
  });

  group('performNotifyNoInternetConnection', () {
    setUp(() {
      init();
      WidgetsFlutterBinding.ensureInitialized();
      // Unregister the original AuthBlocBloc
      if (sl.isRegistered<ConnectivityBlocBloc>()) {
        sl.unregister<ConnectivityBlocBloc>();
      }

      // Register your MockAuthBlocBloc
      sl.registerLazySingleton<ConnectivityBlocBloc>(
          () => mockConnectivityBlocBloc);
    });
    test(
        'Should add LostConnectivityEvent when performNotifyNoInternetConnection is called ',
        () async {
      await coreRepositoryImpl.performNotifyNoInternetConnection();

      verify(mockConnectivityBlocBloc.add(LostConnectivityEvent())).called(1);
    });
  });
}
