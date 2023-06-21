import 'dart:convert';

import 'package:griot_app/accounts/data/models/beloved_ones_list_model.dart';
import 'package:http/http.dart' as http;
import 'package:griot_app/core/data/token_provider.dart';
import 'package:griot_app/core/error/exceptions.dart';

import 'package:griot_app/accounts/data/data_sources/accounts_remote_data_source.dart';
import 'package:griot_app/accounts/data/models/account_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'accounts_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client, TokenProvider])
void main() {
  late AccountsRemoteDataSource datasource;
  late MockClient mockHttpClient;
  late MockTokenProvider mockTokenProvider;

  setUp(() {
    mockHttpClient = MockClient();
    mockTokenProvider = MockTokenProvider();
    datasource = AccountsRemoteDataSourceImpl(
        tokenProvider: mockTokenProvider, client: mockHttpClient);
  });

  group('getAccountDetailsFromAPI', () {
    const int tAccountId = 1;
    const tEndpoint = 'http://app.griot.me/api/account/retrieve/$tAccountId/';
    const tToken = 'yjtcuyrskuhbkjhftrwsujytfciukyhgiutfvk';
    const tHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $tToken',
    };

    final tAccountModel = AccountModel.fromJson(
        json.decode(fixture('account_details_success.json')));

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
            http.Response(fixture('account_details_success.json'), 200));

        // act
        await datasource.getAccountDetailsFromAPI(accountId: tAccountId);

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
              http.Response(fixture('account_details_success.json'), 200));

      // act
      final result =
          await datasource.getAccountDetailsFromAPI(accountId: tAccountId);

      // assert
      expect(result, equals(tAccountModel));
    });

    test('Should throw a ServerException when response code is not 200',
        () async {
      // arrange
      when(mockTokenProvider.getToken())
          .thenAnswer((_) async => 'Token $tToken');
      when(mockHttpClient.get(Uri.parse(tEndpoint), headers: tHeaders))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));

      // act
      final call = datasource.getAccountDetailsFromAPI;

      // assert
      expect(() => call(accountId: tAccountId),
          throwsA(const TypeMatcher<InvalidTokenException>()));
    });
  });

  group('getBelovedOnesListFromAPI', () {
    const int tAccountId = 1;
    const tEndpoint =
        'http://app.griot.me/api/account/list-beloved-ones/$tAccountId/';
    const tToken = 'yjtcuyrskuhbkjhftrwsujytfciukyhgiutfvk';
    const tHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $tToken',
    };

    final iBelovedOnesListModel = BelovedOneListModel.fromJson(json.decode(
        fixture('account_details_success.json'))['beloved_ones_profiles']);

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
            http.Response(fixture('account_details_success.json'), 200));

        // act
        await datasource.getBelovedOnesListFromAPI(accountId: tAccountId);

        // assert
        verify(mockHttpClient.get(
          Uri.parse(tEndpoint),
          headers: tHeaders,
        ));
      },
    );
    test('Should return a List<BelovedOneModel> when response code is 200',
        () async {
      // arrange
      when(mockTokenProvider.getToken())
          .thenAnswer((_) async => 'Token $tToken');
      when(mockHttpClient.get(Uri.parse(tEndpoint), headers: tHeaders))
          .thenAnswer((_) async =>
              http.Response(fixture('account_details_success.json'), 200));

      // act
      final result =
          await datasource.getBelovedOnesListFromAPI(accountId: tAccountId);

      // assert
      expect(result[0], equals(iBelovedOnesListModel.belovedOnes[0]));
    });
    test('Should throw a ServerException when response code is not 200',
        () async {
      // arrange
      when(mockTokenProvider.getToken())
          .thenAnswer((_) async => 'Token $tToken');
      when(mockHttpClient.get(Uri.parse(tEndpoint), headers: tHeaders))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));

      // act
      final call = datasource.getBelovedOnesListFromAPI;

      // assert
      expect(() => call(accountId: tAccountId),
          throwsA(const TypeMatcher<InvalidTokenException>()));
    });
  });
}
