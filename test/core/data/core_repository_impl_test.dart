import 'package:flutter_test/flutter_test.dart';
import 'package:griot_app/core/data/core_repository_impl.dart';

import 'package:griot_app/core/presentation/bloc/user_session_bloc_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core_repository_impl_test.mocks.dart';

@GenerateMocks([UserSessionBlocBloc])
void main() {
  final mockUserSessionBlocBloc = MockUserSessionBlocBloc();
  final coreRepositoryImpl =
      CoreRepositoryImpl(userSessionBloc: mockUserSessionBlocBloc);

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('Calls performTokenExceptionPolicies when passed InvalidTokenException',
      () async {
    await coreRepositoryImpl.performTokenExceptionPolicies();

    verify(mockUserSessionBlocBloc.add(TokenFailedBlocEvent())).called(1);
  });

  test('SharedPreferences removes token', () async {
    final instance = await SharedPreferences.getInstance();
    instance.setString('token', 'testToken');
    await coreRepositoryImpl.performTokenExceptionPolicies();

    final token = instance.getString('token');
    expect(token, null);
  });
}
