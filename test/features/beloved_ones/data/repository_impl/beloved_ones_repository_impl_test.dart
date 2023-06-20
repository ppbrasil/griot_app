import 'package:dartz/dartz.dart';
import 'package:griot_app/beloved_ones/data/data_sources/beloved_ones_remote_data_source.dart';
import 'package:griot_app/beloved_ones/data/models/beloved_one_model.dart';
import 'package:griot_app/beloved_ones/data/repository_impl/beloved_ones_repository_impl.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/network/network_info.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'beloved_ones_repository_impl_test.mocks.dart';

@GenerateMocks([BelovedOnesRemoteDataSource, NetworkInfo])
void main() {
  late BelovedOnesRepositoryImpl repository;
  late MockBelovedOnesRemoteDataSource mockBelovedOnesRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockBelovedOnesRemoteDataSource = MockBelovedOnesRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = BelovedOnesRepositoryImpl(
      remoteDataSource: mockBelovedOnesRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('Use Case: performGeBelovedOnesList', () {
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

    test('Should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockBelovedOnesRemoteDataSource.getBelovedOnesListFromAPI())
          .thenAnswer((_) async => tBelovedOnesList);
      // act
      repository.performGeBelovedOnesList();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('Should return a list of BelovedOne entities', () async {
        // arrange
        when(mockBelovedOnesRemoteDataSource.getBelovedOnesListFromAPI())
            .thenAnswer((_) async => tBelovedOnesList);
        // act
        final result = await repository.performGeBelovedOnesList();
        // assert
        verify(mockBelovedOnesRemoteDataSource.getBelovedOnesListFromAPI());
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
        final result = await repository.performGeBelovedOnesList();
        // assert
        verify(mockNetworkInfo.isConnected);
        verifyNever(
            mockBelovedOnesRemoteDataSource.getBelovedOnesListFromAPI());

        expect(
            result,
            equals(const Left(
                ConnectivityFailure(message: 'No internet connection'))));
      });
    });
  });
}
