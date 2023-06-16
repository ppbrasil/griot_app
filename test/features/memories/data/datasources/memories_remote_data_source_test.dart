import 'dart:convert';

import 'package:griot_app/core/error/exceptions.dart';
import 'package:griot_app/memories/data/data_source/memories_remote_data_source.dart';
import 'package:griot_app/memories/data/models/memory_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';
import 'memories_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MemoriesRemoteDataSourceImpl datasource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    datasource = MemoriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('getMemoryDetailsFromAPI', () {
    final tMemoryId = 1;
    final tEndpoint = 'http://app.griot.me/api/memories/$tMemoryId';
    final tHeaders = {'Content-Type': 'application/json'};

    final tMemoryModel = MemoryModel.fromJson(
        json.decode(fixture('memory_details_success.json')));

    test(
      'Should perform a GET request with memories/{id} endpoint and application/json header',
      () async {
        // arrange
        when(mockHttpClient.get(Uri.parse(tEndpoint), headers: tHeaders))
            .thenAnswer((_) async =>
                http.Response(fixture('memory_details_success.json'), 200));

        // act
        await datasource.getMemoryDetailsFromAPI(memoryId: tMemoryId);

        // assert
        verify(mockHttpClient.get(
          Uri.parse(tEndpoint),
          headers: tHeaders,
        ));
      },
    );

    test('Should return MemoryModel when response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse(tEndpoint), headers: tHeaders))
          .thenAnswer((_) async =>
              http.Response(fixture('memory_details_success.json'), 200));

      // act
      final result =
          await datasource.getMemoryDetailsFromAPI(memoryId: tMemoryId);

      // assert
      expect(result, equals(tMemoryModel));
    });

    test('Should throw a ServerException when response code is not 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse(tEndpoint), headers: tHeaders))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));

      // act
      final call = datasource.getMemoryDetailsFromAPI;

      // assert
      expect(() => call(memoryId: tMemoryId),
          throwsA(const TypeMatcher<InvalidTokenException>()));
    });
  });

  group('getMemoriesListFromAPI', () {
    final tEndpoint = 'http://app.griot.me/api/memories/';
    final tHeaders = {'Content-Type': 'application/json'};

    final tMemoryModelList = [
      MemoryModel.fromJson(json.decode(fixture('memory_details_success.json'))),
      MemoryModel.fromJson(
          json.decode(fixture('memory_details_success_two.json'))),
      MemoryModel.fromJson(
          json.decode(fixture('memory_details_success_three.json'))),
    ];

    test(
      'Should perform a GET request with memories/ endpoint and application/json header',
      () async {
        // arrange
        when(mockHttpClient.get(Uri.parse(tEndpoint), headers: tHeaders))
            .thenAnswer((_) async =>
                http.Response(fixture('memories_list_success.json'), 200));

        // act
        await datasource.getMemoriesListFromAPI();

        // assert
        verify(mockHttpClient.get(
          Uri.parse(tEndpoint),
          headers: tHeaders,
        ));
      },
    );

    test('Should return List<MemoryModel> when response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse(tEndpoint), headers: tHeaders))
          .thenAnswer((_) async =>
              http.Response(fixture('memories_list_success.json'), 200));

      // act
      final result = await datasource.getMemoriesListFromAPI();

      // assert
      expect(result, equals(tMemoryModelList));
    });

    test('Should throw a AuthException when response code is 401', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse(tEndpoint), headers: tHeaders))
          .thenAnswer((_) async => http.Response('Invalid token', 401));

      // act
      final call = datasource.getMemoriesListFromAPI;

      // assert
      expect(() => call(), throwsA(const TypeMatcher<InvalidTokenException>()));
    });
  });

  group('postMemoryToAPI', () {
    final tTitle = 'Test Title';
    final tEndpoint = 'http://app.griot.me/api/memories/';
    final tHeaders = {'Content-Type': 'application/json'};
    final tBody = {"title": tTitle};

    final tMemoryModel = MemoryModel.fromJson(
        json.decode(fixture('memory_details_success.json')));

    test(
      'Should perform a POST request with memories/ endpoint, application/json header, and body',
      () async {
        // arrange
        when(mockHttpClient.post(
          Uri.parse(tEndpoint),
          headers: tHeaders,
          body: jsonEncode(tBody),
        )).thenAnswer((_) async =>
            http.Response(fixture('memory_details_success.json'), 201));

        // act
        await datasource.postMemoryToAPI(title: tTitle);

        // assert
        verify(mockHttpClient.post(
          Uri.parse(tEndpoint),
          headers: tHeaders,
          body: jsonEncode(tBody),
        ));
      },
    );

    test('Should return MemoryModel when response code is 201 (Created)',
        () async {
      // arrange
      when(mockHttpClient.post(
        Uri.parse(tEndpoint),
        headers: tHeaders,
        body: jsonEncode(tBody),
      )).thenAnswer((_) async =>
          http.Response(fixture('memory_details_success.json'), 201));

      // act
      final result = await datasource.postMemoryToAPI(title: tTitle);

      // assert
      expect(result, equals(tMemoryModel));
    });

    test('Should throw a ServerException when response code is not 201',
        () async {
      // arrange
      when(mockHttpClient.post(
        Uri.parse(tEndpoint),
        headers: tHeaders,
        body: jsonEncode(tBody),
      )).thenAnswer((_) async => http.Response('Something went wrong', 400));

      // act
      final call = datasource.postMemoryToAPI;

      // assert
      expect(() => call(title: tTitle),
          throwsA(const TypeMatcher<InvalidTokenException>()));
    });
  });
}
