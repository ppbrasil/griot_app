import 'dart:convert';
import 'package:griot_app/accounts/data/models/account_model.dart';
import 'package:http/http.dart' as http;
import 'package:griot_app/core/data/token_provider.dart';
import 'package:griot_app/core/error/exceptions.dart';

import 'package:griot_app/user/data/data_sources/users_remote_data_source.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'users_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client, TokenProvider])
void main() {
  late UsersRemoteDataSource datasource;
  late MockClient mockHttpClient;
  late MockTokenProvider mockTokenProvider;

  setUp(() {
    mockHttpClient = MockClient();
    mockTokenProvider = MockTokenProvider();
    datasource = UsersRemoteDataSourceImpl(
        tokenProvider: mockTokenProvider, client: mockHttpClient);
  });

  group('getOwnedAccountsListFromAPI', () {
    const tEndpoint = 'http://app.griot.me/api/user/list-accounts/';
    const tToken = 'yjtcuyrskuhbkjhftrwsujytfciukyhgiutfvk';
    const tHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $tToken',
    };

    final List<AccountModel> tOwnedAccountsList = [
      AccountModel.fromJson(
          json.decode(fixture('account_details_success.json'))),
    ];

    test(
      'Should perform a GET request with account endpoint and application/json header',
      () async {
        // arrange
        when(mockTokenProvider.getToken())
            .thenAnswer((_) async => 'Token $tToken');
        when(mockHttpClient.get(
          Uri.parse(tEndpoint),
          headers: tHeaders,
        )).thenAnswer((_) async =>
            http.Response(fixture('user_accounts_sucess.json'), 200));

        // act
        await datasource.getOwnedAccountsListFromAPI();

        // assert
        verify(mockHttpClient.get(
          Uri.parse(tEndpoint),
          headers: tHeaders,
        ));
      },
    );

    test('Should return AccountModel when response code is 200', () async {
      // arrange
      when(mockTokenProvider.getToken())
          .thenAnswer((_) async => 'Token $tToken');
      when(mockHttpClient.get(Uri.parse(tEndpoint), headers: tHeaders))
          .thenAnswer((_) async =>
              http.Response(fixture('user_accounts_sucess.json'), 200));

      // act
      final result = await datasource.getOwnedAccountsListFromAPI();

      // assert
      expect(result, equals(tOwnedAccountsList));
    });
    test('Should throw a ServerException when response code is not 200',
        () async {
      // arrange
      when(mockTokenProvider.getToken())
          .thenAnswer((_) async => 'Token $tToken');
      when(mockHttpClient.get(Uri.parse(tEndpoint), headers: tHeaders))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));

      // act
      final call = datasource.getOwnedAccountsListFromAPI;

      // assert
      expect(() => call(), throwsA(const TypeMatcher<InvalidTokenException>()));
    });
  });
}
