import 'package:griot_app/authentication/domain/entities/token.dart';
import 'package:griot_app/authentication/domain/usecases/perform_login.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:griot_app/authentication/presentation/bloc/auth_bloc.dart';
import 'auth_bloc_test.mocks.dart';
import 'package:bloc_test/bloc_test.dart';

@GenerateMocks([PerformLogin])
void main() {
  late AuthBloc bloc;
  late MockPerformLogin mockPerformLogin;

  setUp(() {
    mockPerformLogin = MockPerformLogin();
    bloc = AuthBloc(performLogin: mockPerformLogin);
  });

  test('initial state should be empty', () {
    // assert
    expect(bloc.state, equals(Empty()));
  });

  group('Perform Login', () {
    const String tUsername = 'myUsername';
    const String tPassword = '123';
    const Token tToken = Token(tokenString: 'wswsxwsc');

    test('Should get data from the concrete usecase', () async {
      // arrange
      when(mockPerformLogin(username: tUsername, password: tPassword))
          .thenAnswer((_) async => const Right(tToken));

      // act
      bloc.add(const SignInWithCredentials(
          password: tPassword, username: tUsername));
      await untilCalled(
          mockPerformLogin(password: tPassword, username: tUsername));

      //assert
      verify(mockPerformLogin(username: tUsername, password: tPassword));
    });

    test('Should emit Empty state when initialized', () async {
      expect(bloc.state, Empty());
    });

    blocTest<AuthBloc, AuthState>(
      'should emit Success state when login is successful',
      build: () {
        when(mockPerformLogin.call(username: 'myUsername', password: '123'))
            .thenAnswer(
          (_) async => const Right(Token(tokenString: 'wswsxwsc')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(
          const SignInWithCredentials(username: 'myUsername', password: '123')),
      expect: () => [Success()],
    );

    blocTest<AuthBloc, AuthState>(
      'should emit Error state when login fails',
      build: () {
        when(mockPerformLogin.call(username: 'myUsername', password: '123'))
            .thenAnswer(
          (_) async => const Left(
              AuthenticationFailure(message: 'Authentication Failed')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(
          const SignInWithCredentials(username: 'myUsername', password: '123')),
      expect: () => [Error()],
    );
  });
}
