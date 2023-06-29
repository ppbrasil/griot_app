import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:griot_app/core/data/griot_http_client_wrapper.dart';
import 'package:griot_app/profile/data/data_sources/profiles_remote_data_source.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:griot_app/core/data/token_provider.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:griot_app/profile/data/models/profile_model.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'profiles_remote_data_source_test.mocks.dart';

@GenerateMocks([GriotHttpServiceWrapper, TokenProvider])
void main() {
  late ProfilesRemoteDataSourceImpl datasource;
  late MockGriotHttpServiceWrapper mockHttpClient;
  late MockTokenProvider mockTokenProvider;

  setUp(() {
    mockHttpClient = MockGriotHttpServiceWrapper();
    mockTokenProvider = MockTokenProvider();
    datasource = ProfilesRemoteDataSourceImpl(
        tokenProvider: mockTokenProvider, client: mockHttpClient);
  });

  group('getProfileDetailsFromAPI', () {
    const tEndpoint = 'http://app.griot.me/api/profile/retrieve/';
    const tToken = 'yjtcuyrskuhbkjhftrwsujytfciukyhgiutfvk';
    const tHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $tToken',
    };

    final tProfileModel = ProfileModel.fromJson(
        json.decode(fixture('profile_details_success.json')));

    test(
      'Should perform a GET request with profile endpoint and application/json header',
      () async {
        // arrange
        when(mockTokenProvider.getToken())
            .thenAnswer((_) async => 'Token $tToken');
        when(mockHttpClient.get(
          Uri.parse(tEndpoint),
          headers: tHeaders,
        )).thenAnswer((_) async =>
            http.Response(fixture('profile_details_success.json'), 200));

        // act
        await datasource.getProfileDetailsFromAPI();

        // assert
        verify(mockHttpClient.get(
          Uri.parse(tEndpoint),
          headers: tHeaders,
        ));
      },
    );

    test('Should return ProfileModel when response code is 200', () async {
      // arrange
      when(mockTokenProvider.getToken())
          .thenAnswer((_) async => 'Token $tToken');
      when(mockHttpClient.get(Uri.parse(tEndpoint), headers: tHeaders))
          .thenAnswer((_) async =>
              http.Response(fixture('profile_details_success.json'), 200));

      // act
      final result = await datasource.getProfileDetailsFromAPI();

      // assert
      expect(result, equals(tProfileModel));
    });

    test('Should throw a ServerException when response code is not 200',
        () async {
      // arrange
      when(mockTokenProvider.getToken())
          .thenAnswer((_) async => 'Token $tToken');
      when(mockHttpClient.get(Uri.parse(tEndpoint), headers: tHeaders))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));

      // act
      final call = datasource.getProfileDetailsFromAPI;

      // assert
      expect(() => call(), throwsA(const TypeMatcher<InvalidTokenException>()));
    });
  });

  group('updateProfileDetailsOverAPI', () {
    const tEndpoint = 'http://app.griot.me/api/profile/update/';
    const tToken = 'yjtcuyrskuhbkjhftrwsujytfciukyhgiutfvk';
    const tHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $tToken',
    };

    const int tYear = 1980;
    const int tMonth = 12;
    const int tDay = 16;
    const String tProfilePicture =
        'https://griot-memories-data.s3.amazonaws.com/profile_pictures/3x4.jpg';
    const String tName = 'Pedro Paulo';
    const String tMiddleName = 'Brasil';
    const String tLastName = 'de Assis Ribeiro';
    final DateTime tBirthdate = DateTime(tYear, tMonth, tDay);
    const String tGender = 'male';
    const String tLanguage = 'pt';
    const String tTimeZone = 'America/Sao_Paulo';

    final tBody = {
      'profile_picture': tProfilePicture,
      'name': tName,
      'middle_name': tMiddleName,
      'last_name': tLastName,
      'birth_date': formatter.format(tBirthdate),
      'gender': tGender,
      'language': tLanguage,
      'timezone': tTimeZone,
    };

    final ProfileModel tProfileModel = ProfileModel.fromJson(
        json.decode(fixture('profile_details_success.json')));

    test(
        'Should perform a PATCH request with memories/ endpoint, application/json header, and body',
        () async {
      // Arrange
      when(mockTokenProvider.getToken())
          .thenAnswer((_) async => 'Token $tToken');
      when(mockHttpClient.patch(
        Uri.parse(tEndpoint),
        headers: tHeaders,
        body: jsonEncode(tBody),
      )).thenAnswer((_) async =>
          http.Response(fixture('profile_details_success.json'), 201));

      // Act
      await datasource.updateProfileDetailsOverAPI(
        profilePicture: tProfilePicture,
        name: tName,
        middleName: tMiddleName,
        lastName: tLastName,
        birthDate: tBirthdate,
        gender: tGender,
        language: tLanguage,
        timeZone: tTimeZone,
      );

      // Assert
      verify(mockHttpClient.patch(
        Uri.parse(tEndpoint),
        headers: tHeaders,
        body: jsonEncode(tBody),
      ));
    });

    test('should return Profile when the response code is 200 (success)',
        () async {
      // Arrange
      when(mockTokenProvider.getToken())
          .thenAnswer((_) async => 'Token $tToken');
      when(mockHttpClient.patch(
        Uri.parse(tEndpoint),
        headers: tHeaders,
        body: jsonEncode(tBody),
      )).thenAnswer((_) async =>
          http.Response(fixture('profile_details_success.json'), 201));

      // Act
      final result = await datasource.updateProfileDetailsOverAPI(
        profilePicture: tProfilePicture,
        name: tName,
        middleName: tMiddleName,
        lastName: tLastName,
        birthDate: tBirthdate,
        gender: tGender,
        language: tLanguage,
        timeZone: tTimeZone,
      );

      // Assert
      expect(result, equals(tProfileModel));
    });

    test(
        'should throw an InvalidTokenException when the response code is not 200',
        () async {
      // Arrange
      when(mockTokenProvider.getToken())
          .thenAnswer((_) async => 'Token $tToken');
      when(mockHttpClient.patch(
        Uri.parse(tEndpoint),
        headers: tHeaders,
        body: jsonEncode(tBody),
      )).thenAnswer((_) async => http.Response('Something went wrong', 400));

      // Act
      final call = datasource.updateProfileDetailsOverAPI;

      // Assert
      expect(
          () => call(
                profilePicture: tProfilePicture,
                name: tName,
                middleName: tMiddleName,
                lastName: tLastName,
                birthDate: tBirthdate,
                gender: tGender,
                language: tLanguage,
                timeZone: tTimeZone,
              ),
          throwsA(const TypeMatcher<InvalidTokenException>()));
    });
  });
}
