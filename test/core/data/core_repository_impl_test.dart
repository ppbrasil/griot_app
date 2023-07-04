import 'package:flutter_test/flutter_test.dart';
import 'package:griot_app/authentication/presentation/bloc/auth_bloc_bloc.dart';
import 'package:griot_app/core/data/core_repository_impl.dart';
import 'package:griot_app/injection_container.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core_repository_impl_test.mocks.dart';

@GenerateMocks([AuthBlocBloc])
void main() {
  final mockAuthBlocBloc = MockAuthBlocBloc();
  final coreRepositoryImpl = CoreRepositoryImpl();

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

  test('Calls performTokenExceptionPolicies when passed InvalidTokenException',
      () async {
    await coreRepositoryImpl.performTokenExceptionPolicies();

    verify(mockAuthBlocBloc.add(TokenFailedEvent())).called(1);
  });

  test('SharedPreferences removes token', () async {
    final instance = await SharedPreferences.getInstance();
    instance.setString('token', 'testToken');
    await coreRepositoryImpl.performTokenExceptionPolicies();

    final token = instance.getString('token');
    expect(token, null);
  });
}
