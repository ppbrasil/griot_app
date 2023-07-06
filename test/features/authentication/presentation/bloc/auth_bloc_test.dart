import 'package:griot_app/authentication/domain/entities/token.dart';
import 'package:griot_app/authentication/domain/usecases/perform_login.dart';
import 'package:griot_app/authentication/domain/usecases/perform_logout.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:griot_app/authentication/presentation/bloc/auth_bloc_bloc.dart';
import 'auth_bloc_test.mocks.dart';
import 'package:bloc_test/bloc_test.dart';

@GenerateMocks([PerformLogin, PerformLogout])
void main() {
  late AuthBlocBloc bloc;
  late MockPerformLogin mockPerformLogin;
  late MockPerformLogout mockPerformLogout;

  setUp(() {
    mockPerformLogin = MockPerformLogin();
    mockPerformLogout = MockPerformLogout();
    bloc = AuthBlocBloc(
      performLogin: mockPerformLogin,
      performLogout: mockPerformLogout,
    );
  });

  test('initial state should be empty', () {
    // assert
    expect(bloc.state, equals(AuthBlocInitialState()));
  });

  group('SignInWithCredentialsEvent', () {
    const String tUsername = 'myUsername';
    const String tPassword = '123';
    const Token tToken = Token(tokenString: 'wswsxwsc');

    test('Should get data from the concrete usecase', () async {
      //arrange
      when(mockPerformLogin(
              const Params(username: tUsername, password: tPassword)))
          .thenAnswer((_) async => const Right(tToken));

      //act
      bloc.add(const SignInWithCredentialsEvent(
          password: tPassword, username: tUsername));
      await untilCalled(mockPerformLogin(
          const Params(password: tPassword, username: tUsername)));

      //assert
      verify(mockPerformLogin(
          const Params(username: tUsername, password: tPassword)));
    });

    test('Should emit Empty state when initialized', () async {
      expect(bloc.state, AuthBlocInitialState());
    });

    blocTest<AuthBlocBloc, AuthBlocState>(
      'should emit Success state when login is successful',
      build: () {
        const tToken = Token(tokenString: 'wswsxwsc');

        when(mockPerformLogin
                .call(const Params(username: 'myUsername', password: '123')))
            .thenAnswer(
          (_) async => Right(Token(tokenString: tToken.tokenString)),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const SignInWithCredentialsEvent(
          username: 'myUsername', password: '123')),
      expect: () => [const AuthBlocAuthorizedState(token: tToken)],
    );

    blocTest<AuthBlocBloc, AuthBlocState>(
      'should emit Error state when login fails',
      build: () {
        when(mockPerformLogin
                .call(const Params(username: 'myUsername', password: '123')))
            .thenAnswer(
          (_) async => const Left(
              AuthenticationFailure(message: 'Authentication Failed')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const SignInWithCredentialsEvent(
          username: 'myUsername', password: '123')),
      expect: () => [AuthBlocLoginFailedState()],
    );
  });
  group('TokenFailedEvent', () {
    blocTest<AuthBlocBloc, AuthBlocState>(
      'should emit UnauthorizedState when InvalidTokenEvent is added',
      build: () => bloc,
      act: (bloc) => bloc.add(TokenFailedEvent()),
      expect: () => [AuthBlocUnauthorizedState()],
    );
  });
  group('LogoutEvent', () {
    blocTest<AuthBlocBloc, AuthBlocState>(
      'should emit AuhtBlocLoggedOutState when LogoutEvent is added and performLogoutUseCase succeeds',
      build: () {
        when(mockPerformLogout.call(const NoParams()))
            .thenAnswer((_) async => const Right(true));
        return bloc;
      },
      act: (bloc) => bloc.add(LogoutEvent()),
      expect: () => [AuhtBlocLoggedOutState()],
    );
    blocTest<AuthBlocBloc, AuthBlocState>(
      'should emit AuthBlocLogoutFailedState when LogoutEvent is added and performLogoutUseCase fails',
      build: () {
        when(mockPerformLogout.call(const NoParams()))
            .thenAnswer((_) async => const Left(InvalidTokenFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(LogoutEvent()),
      expect: () => [AuthBlocLogoutFailedState()],
    );
  });
}
