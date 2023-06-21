import 'package:dartz/dartz.dart';
import 'package:griot_app/accounts/data/data_sources/accounts_remote_data_source.dart';
import 'package:griot_app/accounts/data/models/beloved_one_model.dart';
import 'package:griot_app/accounts/data/repository_impl/accounts_repository_impl.dart';
import 'package:griot_app/accounts/domain/entities/account.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/network/network_info.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'accounts_repository_impl_test.mocks.dart';

@GenerateMocks([AccountsRemoteDataSource, NetworkInfo, ServerException])
void main() {
  late AccountsRepositoryImpl repository;
  late MockAccountsRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  late Account tAccount = const Account(name: 'myAccount');

  setUp(() {
    mockRemoteDataSource = MockAccountsRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AccountsRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });
  group('Repo: performGetAccountDetails', () {
    test(
      'should check if the device is online',
      () async {
        //arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getAccountDetailsFromAPI())
            .thenAnswer((_) async => tAccount);
        //act
        await repository.performGetAccountDetails();
        //assert
        verify(mockNetworkInfo.isConnected).called(1);
      },
    );

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return tAccount when call to remote data source is successfull',
          () async {
        // arrange
        when(mockRemoteDataSource.getAccountDetailsFromAPI())
            .thenAnswer((_) async => tAccount);
        // act
        final result = await repository.performGetAccountDetails();
        // assert
        verify(mockRemoteDataSource.getAccountDetailsFromAPI());
        expect(result, equals(Right(tAccount)));
      });

      test(
          'should return ServerFailure when auth call to remote data source is unsuccessfull',
          () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getAccountDetailsFromAPI())
            .thenThrow(ServerException());
        // act
        final result = await repository.performGetAccountDetails();
        // assert
        verify(mockRemoteDataSource.getAccountDetailsFromAPI());
        expect(
            result,
            equals(
                const Left(ServerFailure(message: 'Unable to retrieve data'))));
      });
    });
  });
  group('Repo: performGetBelovedOnesList', () {
    const tBelovedOneModel1 = BelovedOneModel(
      id: 1,
      profilePicture:
          "https://griot-memories-data.s3.amazonaws.com/profile_pictures/my_profile.jpeg",
      name: "Pedro",
      middleName: null,
      lastName: "Brasil",
      birthDate: null,
      gender: "male",
      language: "pt",
      timeZone: "America/Sao_Paulo",
    );
    const tBelovedOneModel2 = BelovedOneModel(
      id: 4,
      profilePicture: null,
      name: "Bianca",
      middleName: null,
      lastName: "Caffaro",
      birthDate: null,
      gender: "female",
      language: "pt",
      timeZone: "America/Sao_Paulo",
    );
    const tBelovedOneModel3 = BelovedOneModel(
      id: 2,
      profilePicture:
          "https://griot-memories-data.s3.amazonaws.com/profile_pictures/WhatsApp_Image_2023-06-03_at_10.05.53_AM.jpeg",
      name: "Ana Clara",
      middleName: null,
      lastName: "Estephan",
      birthDate: null,
      gender: "female",
      language: "pt",
      timeZone: "America/Sao_Paulo",
    );

    final List<BelovedOneModel> tBelovedOnesList = [
      tBelovedOneModel1, tBelovedOneModel2, tBelovedOneModel3
      // Assuming we have a predefined list of beloved ones
    ];

    const int tAccountId = 1;

    test('Should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getBelovedOnesListFromAPI())
          .thenAnswer((_) async => tBelovedOnesList);
      // act
      repository.performGetBelovedOnesList(accountId: tAccountId);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('Should return a list of BelovedOne entities', () async {
        // arrange
        when(mockRemoteDataSource.getBelovedOnesListFromAPI())
            .thenAnswer((_) async => tBelovedOnesList);
        // act
        final result =
            await repository.performGetBelovedOnesList(accountId: tAccountId);
        // assert
        verify(mockRemoteDataSource.getBelovedOnesListFromAPI());
        verify(mockNetworkInfo.isConnected);
        expect(result, equals(Right(tBelovedOnesList)));
      });
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('Should return a Failure entity', () async {
        // arrange
        // act
        final result =
            await repository.performGetBelovedOnesList(accountId: tAccountId);
        // assert
        verify(mockNetworkInfo.isConnected);
        verifyNever(mockRemoteDataSource.getBelovedOnesListFromAPI());

        expect(
            result,
            equals(const Left(
                ConnectivityFailure(message: 'No internet connection'))));
      });
    });
  });
  group('Repo: performGetBelovedOneDetails', () {
    const int tBelovedOneId = 1;
    const tBelovedOneModel = BelovedOneModel(
      id: 1,
      profilePicture:
          "https://griot-memories-data.s3.amazonaws.com/profile_pictures/my_profile.jpeg",
      name: "Pedro",
      middleName: null,
      lastName: "Brasil",
      birthDate: null,
      gender: "male",
      language: "pt",
      timeZone: "America/Sao_Paulo",
    );
    test(
      'should check if the device is online',
      () async {
        //arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getBelovedOneDetailsFromAPI())
            .thenAnswer((_) async => tBelovedOneModel);
        //act
        await repository.performGetBelovedOneDetails(
            belovedOneId: tBelovedOneId);
        //assert
        verify(mockNetworkInfo.isConnected).called(1);
      },
    );

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return tAccount when call to remote data source is successfull',
          () async {
        // arrange
        when(mockRemoteDataSource.getBelovedOneDetailsFromAPI())
            .thenAnswer((_) async => tBelovedOneModel);
        // act
        final result = await repository.performGetBelovedOneDetails(
            belovedOneId: tBelovedOneId);
        // assert
        verify(mockRemoteDataSource.getBelovedOneDetailsFromAPI());
        expect(result, equals(const Right(tBelovedOneModel)));
      });

      test(
          'should return ServerFailure when auth call to remote data source is unsuccessfull',
          () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getBelovedOneDetailsFromAPI())
            .thenThrow(ServerException());
        // act
        final result = await repository.performGetBelovedOneDetails(
            belovedOneId: tBelovedOneId);
        // assert
        verify(mockRemoteDataSource.getBelovedOneDetailsFromAPI());
        expect(
            result,
            equals(
                const Left(ServerFailure(message: 'Unable to retrieve data'))));
      });
    });
  });
}
