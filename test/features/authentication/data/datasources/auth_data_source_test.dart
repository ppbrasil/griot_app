import 'dart:convert';

import 'package:griot_app/authentication/data/data_sources/auth_data_source.dart';
import 'package:griot_app/authentication/data/models/token_model.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';
import 'auth_data_source_test.mocks.dart';

//class MockHttClient extends Mock implements http.Client {}

@GenerateMocks([http.Client])
void main(){
  late AuthRemoteDataSourceImpl datasource;
  late MockClient mockHttClient;

  setUp(() {
    mockHttClient = MockClient();
    datasource = AuthRemoteDataSourceImpl(client: mockHttClient);
  });

  group('login', () { 
    const tUsername = 'ppbrasil@gmail.com';
    const tPassword = 'q1w2e3r4t5';
    const tEndpoint = 'http://app.griot.me/api/user/auth/';
    const tBody = {
    'username': 'ppbrasil@gmail.com',
    'password': 'q1w2e3r4t5',
     };
    const tHeaders =  {'Content-Type': 'application/json',};
    final tTokenModel = 
        TokenModel.fromJson(json.decode(fixture('auth_success_response.json')));

    test('Should perform a POST request with user/auth/ endpoint and application/jason header', 
      () async {
        // arrange
        when(mockHttClient.post(Uri.parse(tEndpoint), headers: tHeaders, body: tBody))
          .thenAnswer((_) async => http.Response(fixture('auth_success_response.json'), 200));
        // act
        datasource.login(tUsername, tPassword);
        // assert
        verify(mockHttClient.post(
          Uri.parse('http://app.griot.me/api/user/auth/'),
          headers:  {'Content-Type': 'application/json',},
          body: {'username': 'ppbrasil@gmail.com', 'password': 'q1w2e3r4t5'},
        ));
      },
    );

    test('Should return Token when response code is 200', 
    () async {
      // arrange
        when(mockHttClient.post(Uri.parse(tEndpoint), headers: tHeaders, body: tBody))
          .thenAnswer((_) async => http.Response(fixture('auth_success_response.json'), 200));
      // act
        final result = await datasource.login(tUsername, tPassword);

      // assert
        expect(result, equals(tTokenModel));
    });

    test('Should throw a ServerException when code is not 200', 
    () async {
      // arrange
        when(mockHttClient.post(Uri.parse(tEndpoint), headers: tHeaders, body: tBody))
          .thenAnswer((_) async => http.Response(fixture('auth_invalid_response.json'), 404));
      // act
        final call = datasource.login;

      // assert
        expect(()=> call(tUsername, tPassword), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}