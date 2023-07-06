import 'package:flutter_test/flutter_test.dart';
import 'package:griot_app/authentication/presentation/bloc/auth_bloc_bloc.dart';
import 'package:griot_app/core/data/core_repository_impl.dart';
import 'package:griot_app/injection_container.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core_repository_impl_test.mocks.dart';

@GenerateMocks([AuthBlocBloc, SharedPreferences])
void main() {
  final mockSharedPreferences = MockSharedPreferences();
  final mockAuthBlocBloc = MockAuthBlocBloc();
  final coreRepositoryImpl =
      CoreRepositoryImpl(sharedPreferences: mockSharedPreferences);

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
}
