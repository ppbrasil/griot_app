import 'dart:convert';

import 'package:griot_app/authentication/data/data_sources/auth_data_source.dart';
import 'package:griot_app/authentication/data/models/token_model.dart';
import 'package:griot_app/core/data/griot_http_client_wrapper.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';
import 'auth_data_source_test.mocks.dart';

@GenerateMocks([GriotHttpServiceWrapper])
void main() {
  late MockGriotHttpServiceWrapper mockHttClient;
  late AuthRemoteDataSourceImpl datasource;

  setUp(() {
    mockHttClient = MockGriotHttpServiceWrapper();
    datasource = AuthRemoteDataSourceImpl(client: mockHttClient);
  });

  group('login', () {
    const tUsername = 'user@example.com';
    const tPassword = 'myPassword';
    const tEndpoint = 'http://app.griot.me/api/user/auth/';
    const tBody = {
      "username": tUsername,
      "password": tPassword,
    };

    const tHeaders = {
      'Content-Type': 'application/json',
    };
    final tTokenModel =
        TokenModel.fromJson(json.decode(fixture('auth_success_response.json')));

    test(
      'Should perform a POST request with user/auth/ endpoint and application/jason header',
      () async {
        // arrange
        when(mockHttClient.post(Uri.parse(tEndpoint),
                headers: tHeaders, body: jsonEncode(tBody)))
            .thenAnswer((_) async =>
                http.Response(fixture('auth_success_response.json'), 200));

        datasource.login(tUsername, tPassword);
        // assert
        verify(mockHttClient.post(
          Uri.parse(tEndpoint),
          headers: tHeaders,
          body: jsonEncode(tBody),
        ));
      },
    );

    test('Should return Token when response code is 200', () async {
      // arrange
      when(mockHttClient.post(Uri.parse(tEndpoint),
              headers: tHeaders, body: jsonEncode(tBody)))
          .thenAnswer((_) async =>
              http.Response(fixture('auth_success_response.json'), 200));
      // act
      final result = await datasource.login(tUsername, tPassword);

      // assert
      expect(result, equals(tTokenModel));
    });

    test('Should throw a InvalidTokenException when code is not 200', () async {
      // arrange
      when(mockHttClient.post(Uri.parse(tEndpoint),
              headers: tHeaders, body: jsonEncode(tBody)))
          .thenAnswer((_) async =>
              http.Response(fixture('auth_invalid_response.json'), 404));
      // act
      final call = datasource.login;

      // assert
      expect(() => call(tUsername, tPassword),
          throwsA(const TypeMatcher<InvalidTokenException>()));
    });
  });
}
