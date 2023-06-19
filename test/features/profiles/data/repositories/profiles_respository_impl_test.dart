import 'package:dartz/dartz.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/network/network_info.dart';
import 'package:griot_app/profile/data/data_sources/profiles_remote_data_source.dart';
import 'package:griot_app/profile/data/models/profile_model.dart';
import 'package:griot_app/profile/data/repositories_impl/profiles_respository_impl.dart';
import 'package:griot_app/profile/domain/entities/profile.dart';
import 'package:griot_app/profile/domain/use_cases/perform_update_profile_dateils.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';

import 'profiles_respository_impl_test.mocks.dart';

@GenerateMocks([ProfilesRemoteDataSource, NetworkInfo])
void main() {
  late ProfilesRepositoryImpl repository;
  late MockProfilesRemoteDataSource mockProfilesRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  const int tYear = 1980;
  const int tMonth = 12;
  const int tDay = 16;
  const int tId = 1;
  const String tProfilePricture =
      'https://griot-memories-data.s3.amazonaws.com/profile_pictures/3x4.jpg';
  const String tName = 'Pedro Paulo';
  const String tMiddleName = 'Brasil';
  const String tLastName = 'de Assis Ribeiro';
  final DateTime tBirthdate = DateTime(tYear, tMonth, tDay);
  const String tGender = 'male';
  const String tLanguage = 'pt';
  const String tTimezone = 'America/Sao_Paulo';

  final ProfileModel tProfileModel = ProfileModel(
    id: tId,
    name: tName,
    middleName: tMiddleName,
    lastName: tLastName,
    profilePicture: tProfilePricture,
    birthDate: tBirthdate,
    gender: tGender,
    language: tLanguage,
    timeZone: tTimezone,
  );

  setUp(() {
    mockProfilesRemoteDataSource = MockProfilesRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProfilesRepositoryImpl(
      remoteDataSource: mockProfilesRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('Use Case: performGetProfileDetail', () {
    final Profile tProfile = tProfileModel;

    test('Should check if the device is online when data_source is called',
        () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockProfilesRemoteDataSource.getProfileDetailsFromAPI())
          .thenAnswer((_) async => tProfileModel);
      // act
      repository.performGetProfileDetails();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group(' when device is oneline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('Should return a Profile entity when data_source is called ',
          () async {
        // arrange
        when(mockProfilesRemoteDataSource.getProfileDetailsFromAPI())
            .thenAnswer((_) async => tProfileModel);
        // act
        final result = await repository.performGetProfileDetails();
        // assert
        verify(mockProfilesRemoteDataSource.getProfileDetailsFromAPI());
        verify(mockNetworkInfo.isConnected);
        expect(result, equals(Right(tProfile)));
      });
    });

    group(' when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      test('Should return a Failure entity when data_source is called ',
          () async {
        // arrange
        // act
        final result = await repository.performGetProfileDetails();
        // assert
        verify(mockNetworkInfo.isConnected);
        verifyNever(mockProfilesRemoteDataSource.getProfileDetailsFromAPI());

        expect(
            result,
            equals(const Left(
                ConnectivityFailure(message: 'No internet connection'))));
      });
    });
  });

  group('Use Case: performUpdateProfileDetails', () {
    final Profile tProfile = tProfileModel;

    test('Should check if the device is online when data_source is called',
        () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockProfilesRemoteDataSource.updateProfileDetailsOverAPI(
        profilePicture: tProfilePricture,
        name: tName,
        middleName: tMiddleName,
        lastName: tLastName,
        birthDate: tBirthdate,
        gender: tGender,
        language: tLanguage,
        timeZone: tTimezone,
      )).thenAnswer((_) async => tProfileModel);
      // act
      await repository.performUpdateProfileDetails(
        profilePicture: tProfilePricture,
        name: tName,
        middleName: tMiddleName,
        lastName: tLastName,
        birthDate: tBirthdate,
        gender: tGender,
        language: tLanguage,
        timeZone: tTimezone,
      );
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group(' when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('Should return a Profile entity when data_source is called ',
          () async {
        // arrange
        when(mockProfilesRemoteDataSource.updateProfileDetailsOverAPI(
          profilePicture: tProfilePricture,
          name: tName,
          middleName: tMiddleName,
          lastName: tLastName,
          birthDate: tBirthdate,
          gender: tGender,
          language: tLanguage,
          timeZone: tTimezone,
        )).thenAnswer((_) async => tProfileModel);
        // act
        final result = await repository.performUpdateProfileDetails(
          profilePicture: tProfilePricture,
          name: tName,
          middleName: tMiddleName,
          lastName: tLastName,
          birthDate: tBirthdate,
          gender: tGender,
          language: tLanguage,
          timeZone: tTimezone,
        );
        // assert
        verify(mockProfilesRemoteDataSource.updateProfileDetailsOverAPI(
          profilePicture: tProfilePricture,
          name: tName,
          middleName: tMiddleName,
          lastName: tLastName,
          birthDate: tBirthdate,
          gender: tGender,
          language: tLanguage,
          timeZone: tTimezone,
        ));
        verify(mockNetworkInfo.isConnected);
        expect(result, equals(Right(tProfile)));
      });
    });

    group(' when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      test('Should return a Failure entity when data_source is called ',
          () async {
        // arrange
        // act
        final result = await repository.performUpdateProfileDetails(
          profilePicture: tProfilePricture,
          name: tName,
          middleName: tMiddleName,
          lastName: tLastName,
          birthDate: tBirthdate,
          gender: tGender,
          language: tLanguage,
          timeZone: tTimezone,
        );
        // assert
        verify(mockNetworkInfo.isConnected);
        verifyNever(mockProfilesRemoteDataSource.updateProfileDetailsOverAPI(
          profilePicture: tProfilePricture,
          name: tName,
          middleName: tMiddleName,
          lastName: tLastName,
          birthDate: tBirthdate,
          gender: tGender,
          language: tLanguage,
          timeZone: tTimezone,
        ));

        expect(
            result,
            equals(const Left(
                ConnectivityFailure(message: 'No internet connection'))));
      });
    });
  });
}
