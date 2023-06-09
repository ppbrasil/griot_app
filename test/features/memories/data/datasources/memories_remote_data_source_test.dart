import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:griot_app/core/data/griot_http_client_wrapper.dart';
import 'package:griot_app/core/data/token_provider.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:griot_app/core/services/thumbnail_services.dart';
import 'package:griot_app/memories/data/data_source/memories_remote_data_source.dart';
import 'package:griot_app/memories/data/models/memory_model.dart';
import 'package:griot_app/memories/data/models/video_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';
import 'memories_remote_data_source_test.mocks.dart';

@GenerateMocks([GriotHttpServiceWrapper, TokenProvider, ThumbnailService])
void main() {
  late MemoriesRemoteDataSourceImpl datasource;
  late MockGriotHttpServiceWrapper mockHttpClient;
  late MockTokenProvider mockTokenProvider;
  late MockThumbnailService mockThumbnailService;

  setUp(() {
    mockHttpClient = MockGriotHttpServiceWrapper();
    mockTokenProvider = MockTokenProvider();
    mockThumbnailService = MockThumbnailService();
    datasource = MemoriesRemoteDataSourceImpl(
      tokenProvider: mockTokenProvider,
      client: mockHttpClient,
      thumbnailService: mockThumbnailService,
    );
  });

  group('getMemoryDetailsFromAPI', () {
    const tVideoOneId = 37;
    const tVideoOneFile =
        "https://griot-memories-data.s3.amazonaws.com/videos/78-14027.mp4";
    const tVideoOneMemorId = 78;

    VideoModel tVideoOne = const VideoModel(
      id: tVideoOneId,
      file: tVideoOneFile,
      memoryId: tVideoOneMemorId,
    );

    const tVideoTwoId = 38;
    const tVideoTwoFile =
        "https://griot-memories-data.s3.amazonaws.com/videos/78-14028.mp4";
    const tVideoTwoMemorId = 78;

    VideoModel tVideoTwo = const VideoModel(
      id: tVideoTwoId,
      file: tVideoTwoFile,
      memoryId: tVideoTwoMemorId,
    );

    const tMemoryId = 78;
    const tAccountid = 1;
    const tTitle = "My First Memory";

    MemoryModel tMemoryModel = MemoryModel(
      id: tMemoryId,
      accountId: tAccountid,
      title: tTitle,
      videos: [tVideoOne, tVideoTwo],
    );

    const tEndpoint = 'http://app.griot.me/api/memory/retrieve/$tMemoryId/';
    const tToken = 'yjtcuyrskuhbkjhftrwsujytfciukyhgiutfvk';
    const tHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $tToken',
    };

//    final tMemoryModel = MemoryModel.fromJson(
//        json.decode(fixture('memory_details_success.json')));

    test(
      'Should perform a GET request with memories/{id} endpoint and application/json header',
      () async {
        // arrange

        when(mockTokenProvider.getToken())
            .thenAnswer((_) async => 'Token $tToken');

        when(mockHttpClient.get(
          Uri.parse(tEndpoint),
          headers: tHeaders,
        )).thenAnswer((_) async =>
            Right(http.Response(fixture('memory_details_success.json'), 200)));

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
      when(mockTokenProvider.getToken())
          .thenAnswer((_) async => 'Token $tToken');
      when(mockHttpClient.get(Uri.parse(tEndpoint), headers: tHeaders))
          .thenAnswer((_) async => Right(
              http.Response(fixture('memory_details_success.json'), 200)));

      // act
      final result =
          await datasource.getMemoryDetailsFromAPI(memoryId: tMemoryId);

      // assert
      expect(result, equals(tMemoryModel));
    });

    test('Should throw a ServerException when response code is not 200',
        () async {
      // arrange
      when(mockTokenProvider.getToken())
          .thenAnswer((_) async => 'Token $tToken');
      when(mockHttpClient.get(Uri.parse(tEndpoint), headers: tHeaders))
          .thenAnswer(
              (_) async => Right(http.Response('Something went wrong', 404)));

      // act
      final call = datasource.getMemoryDetailsFromAPI;

      // assert
      expect(() => call(memoryId: tMemoryId),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getMemoriesListFromAPI', () {
    const tEndpoint = 'http://app.griot.me/api/memory/list/';
    const tToken = "yjtcuyrskuhbkjhftrwsujytfciukyhgiutfvk";
    const tHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $tToken',
    };

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
        when(mockTokenProvider.getToken())
            .thenAnswer((_) async => 'Token $tToken');
        when(mockHttpClient.get(Uri.parse(tEndpoint), headers: tHeaders))
            .thenAnswer((_) async => Right(
                http.Response(fixture('memories_list_success.json'), 200)));

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
      when(mockTokenProvider.getToken())
          .thenAnswer((_) async => 'Token $tToken');
      when(mockHttpClient.get(Uri.parse(tEndpoint), headers: tHeaders))
          .thenAnswer((_) async =>
              Right(http.Response(fixture('memories_list_success.json'), 200)));

      // act
      final result = await datasource.getMemoriesListFromAPI();

      // assert
      expect(result, equals(tMemoryModelList));
    });

    test('Should throw a AuthException when response code is 401', () async {
      // arrange
      when(mockTokenProvider.getToken())
          .thenAnswer((_) async => 'Token $tToken');
      when(mockHttpClient.get(Uri.parse(tEndpoint), headers: tHeaders))
          .thenAnswer((_) async => Right(http.Response('Invalid token', 401)));

      // act
      final call = datasource.getMemoriesListFromAPI;

      // assert
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('postMemoryToAPI', () {
    const tAccountId = 1;
    const tTitle = 'My First Memory';
    const tEndpoint = 'http://app.griot.me/api/memory/create/';
    const tToken = "yjtcuyrskuhbkjhftrwsujytfciukyhgiutfvk";
    const tHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $tToken',
    };
    const tBody = {
      "account": tAccountId,
      "title": tTitle,
    };

    final tMemoryModel = MemoryModel.fromJson(
        json.decode(fixture('memory_details_success.json')));

    test(
      'Should perform a POST request with memories/ endpoint, application/json header, and body',
      () async {
        // arrange
        when(mockTokenProvider.getToken())
            .thenAnswer((_) async => 'Token $tToken');
        when(mockHttpClient.post(
          Uri.parse(tEndpoint),
          headers: tHeaders,
          body: jsonEncode(tBody),
        )).thenAnswer((_) async =>
            Right(http.Response(fixture('memory_details_success.json'), 201)));

        // act
        await datasource.postMemoryToAPI(memory: tMemoryModel);

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
      when(mockTokenProvider.getToken())
          .thenAnswer((_) async => 'Token $tToken');
      when(mockHttpClient.post(
        Uri.parse(tEndpoint),
        headers: tHeaders,
        body: jsonEncode(tBody),
      )).thenAnswer((_) async =>
          Right(http.Response(fixture('memory_details_success.json'), 201)));

      // act
      final result = await datasource.postMemoryToAPI(memory: tMemoryModel);

      // assert
      expect(result, equals(tMemoryModel));
    });

    test('Should throw a ServerException when response code is not 201',
        () async {
      // arrange
      when(mockTokenProvider.getToken())
          .thenAnswer((_) async => 'Token $tToken');
      when(mockHttpClient.post(
        Uri.parse(tEndpoint),
        headers: tHeaders,
        body: jsonEncode(tBody),
      )).thenAnswer(
          (_) async => Right(http.Response('Something went wrong', 400)));

      // act
      final call = datasource.postMemoryToAPI;

      // assert
      expect(() => call(memory: tMemoryModel),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('deteleVideoFromAPI', () {
    const int tId = 1;

    const tToken = "yjtcuyrskuhbkjhftrwsujytfciukyhgiutfvk";
    const tEndpoint = 'http://app.griot.me/api/video/delete/$tId/';
    const tHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $tToken',
    };

    test(
      'Should perform a DELETE request with memories/ endpoint, application/json header, and body',
      () async {
        // arrange
        when(mockTokenProvider.getToken())
            .thenAnswer((_) async => 'Token $tToken');
        when(mockHttpClient.delete(
          Uri.parse(tEndpoint),
          headers: tHeaders,
        )).thenAnswer((_) async =>
            Right(http.Response(fixture('video_delete_sucess.json'), 201)));

        // act
        await datasource.deleteVideoFromAPI(videoId: tId);

        // assert
        verify(mockHttpClient.delete(
          Uri.parse(tEndpoint),
          headers: tHeaders,
        ));
      },
    );

    test('Should return 0 when response code is 201', () async {
      // arrange
      when(mockTokenProvider.getToken())
          .thenAnswer((_) async => 'Token $tToken');
      when(mockHttpClient.delete(
        Uri.parse(tEndpoint),
        headers: tHeaders,
      )).thenAnswer((_) async =>
          Right(http.Response(fixture('video_delete_sucess.json'), 201)));

      // act
      final result = await datasource.deleteVideoFromAPI(videoId: tId);

      // assert
      expect(result, equals(0));
    });

    test('Should throw a TokenException when response code is not 201',
        () async {
      // arrange
      when(mockTokenProvider.getToken())
          .thenAnswer((_) async => 'Token $tToken');
      when(mockHttpClient.delete(
        Uri.parse(tEndpoint),
        headers: tHeaders,
      )).thenAnswer(
          (_) async => Right(http.Response('Something went wrong', 400)));

      // act
      final call = datasource.deleteVideoFromAPI;

      // assert
      expect(() => call(videoId: tId),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('updateMemoryToAPI', () {
    const tMemoryId = 1;
    const tNewTitle = 'Updated title';

    const tAccountId = 1;

    const tEndpoint = 'http://app.griot.me/api/memory/update/$tMemoryId/';
    const tToken = "yjtcuyrskuhbkjhftrwsujytfciukyhgiutfvk";
    const tHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $tToken',
    };
    Map<String, dynamic> tBody = {
      "account": tAccountId,
      "title": tNewTitle,
    };

    final tMemoryModel = MemoryModel.fromJson(
        json.decode(fixture('memory_update_success.json')));

    test(
      'Should perform a POST request with memories/ endpoint, application/json header, and body',
      () async {
        // arrange
        when(mockTokenProvider.getToken())
            .thenAnswer((_) async => 'Token $tToken');
        when(mockHttpClient.patch(
          Uri.parse(tEndpoint),
          headers: tHeaders,
          body: jsonEncode(tBody),
        )).thenAnswer((_) async =>
            Right(http.Response(fixture('memory_details_success.json'), 201)));

        // act
        await datasource.patchUpdateMemoryToAPI(memory: tMemoryModel);

        // assert
        verify(mockHttpClient.patch(
          Uri.parse(tEndpoint),
          headers: tHeaders,
          body: jsonEncode(tBody),
        ));
      },
    );
  });
}
