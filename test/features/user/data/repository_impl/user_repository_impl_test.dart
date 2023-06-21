import 'package:flutter_test/flutter_test.dart';
import 'package:griot_app/accounts/data/models/account_model.dart';
import 'package:griot_app/accounts/domain/entities/account.dart';
import 'package:griot_app/user/data/data_sources/users_remote_data_source.dart';
import 'package:griot_app/user/data/repository_impl/users_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:dartz/dartz.dart';

import 'package:griot_app/core/error/exceptions.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/network/network_info.dart';

import 'user_repository_impl_test.mocks.dart';

@GenerateMocks([UsersRemoteDataSource, NetworkInfo, ServerException])
void main() {
  late UsersRepositoryImpl repository;
  late MockUsersRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockUsersRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = UsersRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('Repo: performGetBelovedAccountsList', () {
    AccountModel belovedAccount1 =
        const AccountModel(id: 1, name: 'Account One');
    AccountModel belovedAccount2 =
        const AccountModel(id: 2, name: 'Account Two');
    List<Account> belovedAccountsList = [belovedAccount1, belovedAccount2];

    test(
      'should check if the device is online',
      () async {
        //arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getBelovedAccountsListFromAPI())
            .thenAnswer((_) async => belovedAccountsList);
        //act
        await repository.performGetBelovedAccountsList();
        //assert
        verify(mockNetworkInfo.isConnected).called(1);
      },
    );
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return BelovedAccounstList when call to remote data source is successfull',
          () async {
        // arrange
        when(mockRemoteDataSource.getBelovedAccountsListFromAPI())
            .thenAnswer((_) async => belovedAccountsList);
        // act
        final result = await repository.performGetBelovedAccountsList();
        // assert
        verify(mockRemoteDataSource.getBelovedAccountsListFromAPI());
        expect(result, equals(Right(belovedAccountsList)));
      });
      test(
          'should return ServerFailure when auth call to remote data source is unsuccessfull',
          () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getBelovedAccountsListFromAPI())
            .thenThrow(ServerException());
        // act
        final result = await repository.performGetBelovedAccountsList();
        // assert
        verify(mockRemoteDataSource.getBelovedAccountsListFromAPI());
        expect(
            result,
            equals(
                const Left(ServerFailure(message: 'Unable to retrieve data'))));
      });
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('Should return a Failure entity', () async {
        // arrange
        // act
        final result = await repository.performGetBelovedAccountsList();
        // assert
        verify(mockNetworkInfo.isConnected);
        verifyNever(mockRemoteDataSource.getBelovedAccountsListFromAPI());

        expect(
            result,
            equals(const Left(
                ConnectivityFailure(message: 'No internet connection'))));
      });
    });
  });

  group('Repo: performGetOwnedAccountsList', () {
    AccountModel belovedAccount1 =
        const AccountModel(id: 1, name: 'Account One');
    AccountModel belovedAccount2 =
        const AccountModel(id: 2, name: 'Account Two');
    List<Account> belovedAccountsList = [belovedAccount1, belovedAccount2];

    test(
      'should check if the device is online',
      () async {
        //arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getOwnedAccountsListFromAPI())
            .thenAnswer((_) async => belovedAccountsList);
        //act
        await repository.performGetOwnedAccountsList();
        //assert
        verify(mockNetworkInfo.isConnected).called(1);
      },
    );
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return BelovedAccounstList when call to remote data source is successfull',
          () async {
        // arrange
        when(mockRemoteDataSource.getOwnedAccountsListFromAPI())
            .thenAnswer((_) async => belovedAccountsList);
        // act
        final result = await repository.performGetOwnedAccountsList();
        // assert
        verify(mockRemoteDataSource.getOwnedAccountsListFromAPI());
        expect(result, equals(Right(belovedAccountsList)));
      });
      test(
          'should return ServerFailure when auth call to remote data source is unsuccessfull',
          () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getOwnedAccountsListFromAPI())
            .thenThrow(ServerException());
        // act
        final result = await repository.performGetOwnedAccountsList();
        // assert
        verify(mockRemoteDataSource.getOwnedAccountsListFromAPI());
        expect(
            result,
            equals(
                const Left(ServerFailure(message: 'Unable to retrieve data'))));
      });
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('Should return a Failure entity', () async {
        // arrange
        // act
        final result = await repository.performGetOwnedAccountsList();
        // assert
        verify(mockNetworkInfo.isConnected);
        verifyNever(mockRemoteDataSource.getOwnedAccountsListFromAPI());

        expect(
            result,
            equals(const Left(
                ConnectivityFailure(message: 'No internet connection'))));
      });
    });
  });
}
