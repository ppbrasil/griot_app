import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:griot_app/accounts/domain/entities/account.dart';
import 'package:griot_app/authentication/data/data_sources/auth_data_source.dart';
import 'package:griot_app/authentication/data/models/token_model.dart';
import 'package:griot_app/authentication/data/repositories/auth_repository_impl.dart';
import 'package:griot_app/authentication/domain/entities/token.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/network/network_info.dart';
import 'package:griot_app/user/data/data_sources/users_remote_data_source.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSource, UsersRemoteDataSource, NetworkInfo])
void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockAuthRemoteDataSource;
  late MockUsersRemoteDataSource mockUsersRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  const tEmail = 'ppbrasil@gmail.com';
  const tPassword = 'q1w2e3r4t5';
  const tTokenModel = TokenModel(tokenString: 'q1w2io8yvoihpedvefdv');
  const Token tToken = tTokenModel;
  List<Account> tAccountList = [
    const Account(name: 'a'),
    const Account(name: 'b'),
  ];

  setUp(() {
    mockAuthRemoteDataSource = MockAuthRemoteDataSource();
    mockUsersRemoteDataSource = MockUsersRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = AuthRepositoryImpl(
      remoteDataSource: mockAuthRemoteDataSource,
      usersRemoteDataSource: mockUsersRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });
  group('login', () {
    test(
      'should check if the device is online',
      () async {
        //arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockAuthRemoteDataSource.login(tEmail, tPassword))
            .thenAnswer((_) async => tTokenModel);
        when(mockUsersRemoteDataSource.getOwnedAccountsListFromAPI())
            .thenAnswer((_) async => tAccountList);
        when(mockUsersRemoteDataSource.storeMainAccountId(
                mainAccountId: tAccountList[0].id))
            .thenAnswer((_) async => Void);
        //act
        await repository.login(username: tEmail, password: tPassword);
        //assert
        verify(mockNetworkInfo.isConnected).called(1);
      },
    );

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return data when auth call to remote data source is successfull',
          () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockAuthRemoteDataSource.login(tEmail, tPassword))
            .thenAnswer((_) async => tTokenModel);
        when(mockUsersRemoteDataSource.getOwnedAccountsListFromAPI())
            .thenAnswer((_) async => tAccountList);
        when(mockUsersRemoteDataSource.storeMainAccountId(
                mainAccountId: tAccountList[0].id))
            .thenAnswer((_) async => Void);
        // act
        final result =
            await repository.login(username: tEmail, password: tPassword);
        // assert
        verify(mockAuthRemoteDataSource.login(tEmail, tPassword));
        expect(result, equals(const Right(tToken)));
      });

      test(
          'should perssit token when auth call to remote data source is successfull',
          () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockAuthRemoteDataSource.login(tEmail, tPassword))
            .thenAnswer((_) async => tTokenModel);
        when(mockUsersRemoteDataSource.getOwnedAccountsListFromAPI())
            .thenAnswer((_) async => tAccountList);
        when(mockUsersRemoteDataSource.storeMainAccountId(
                mainAccountId: tAccountList[0].id))
            .thenAnswer((_) async => Void);
        // act
        await repository.login(username: tEmail, password: tPassword);
        // assert
        verify(mockAuthRemoteDataSource.login(tEmail, tPassword));
        verify(mockAuthRemoteDataSource
            .storeTokenToSharedPreferences(tTokenModel));
      });

      test(
          'should return Auth failure when auth call to remote data source is unsuccessfull',
          () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockAuthRemoteDataSource.login(tEmail, tPassword))
            .thenThrow(ServerException());
        // act
        final result =
            await repository.login(username: tEmail, password: tPassword);
        // assert
        verify(mockAuthRemoteDataSource.login(tEmail, tPassword));
        expect(
            result,
            equals(
                const Left(ServerFailure(message: 'Authentication failed'))));
      });
    });
  });

  group('Logout', () {
    test('should destroy the toekn when call is successfull', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockAuthRemoteDataSource.destroyTokenFromSharedPreferences())
          .thenAnswer((_) async => true);

      // Act
      final result = await repository.logout();

      // Assert
      expect(result, equals(const Right(true)));
      verify(mockAuthRemoteDataSource.destroyTokenFromSharedPreferences())
          .called(1);
    });

    test('should return InvalidTokenFailure when the token is invalid',
        () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockAuthRemoteDataSource.destroyTokenFromSharedPreferences())
          .thenThrow(InvalidTokenException());

      // Act
      final result = await repository.logout();

      // Assert
      expect(result, equals(const Left(InvalidTokenFailure())));
      verify(mockAuthRemoteDataSource.destroyTokenFromSharedPreferences())
          .called(1);
    });

    test('should return NetworkFailure when the connection is not available',
        () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockAuthRemoteDataSource.destroyTokenFromSharedPreferences())
          .thenThrow(NetworkException());

      // Act
      final result = await repository.logout();

      // Assert
      expect(
          result,
          equals(const Left(
              ConnectivityFailure(message: 'Internet is not available'))));
      verify(mockAuthRemoteDataSource.destroyTokenFromSharedPreferences())
          .called(1);
    });
  });
}
