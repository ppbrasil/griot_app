import 'package:dartz/dartz.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:griot_app/core/error/failures.dart';

import 'package:griot_app/core/network/network_info.dart';
import 'package:griot_app/memories/data/data_source/memories_remote_data_source.dart';
import 'package:griot_app/memories/data/models/memory_model.dart';
import 'package:griot_app/memories/data/repositories/memory_processor.dart';
import 'package:griot_app/memories/data/repositories/video_processor.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/domain/entities/video.dart';

import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';

import 'memory_processor_test.mocks.dart';

@GenerateMocks([NetworkInfo, MemoriesRemoteDataSource, VideoProcessingService])
void main() {
  late MemoryProcessor memoryCreator;
  late MemoryProcessor memoryUpdater;
  late MockNetworkInfo mockNetworkInfo;
  late MockVideoProcessingService mockVideoProcessingServices;
  late MockMemoriesRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockVideoProcessingServices = MockVideoProcessingService();
    mockRemoteDataSource = MockMemoriesRemoteDataSource();
    memoryCreator = MemoryCreator(
      networkInfo: mockNetworkInfo,
      videoProcessingService: mockVideoProcessingServices,
      remoteDataSource: mockRemoteDataSource,
    );
    memoryUpdater = MemoryUpdater(
      networkInfo: mockNetworkInfo,
      videoProcessingService: mockVideoProcessingServices,
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group('MemoryCreator', () {
    List<Video> tTobeAddedVideoList = [
      const Video(
        id: 1,
        file: 'myPath',
        thumbnail: null,
        name: 'myVideo',
        memoryId: 1,
        thumbnailData: null,
      )
    ];
    Memory tDraftMemory = Memory(
        id: null, title: 'MyMemory', accountId: 1, videos: tTobeAddedVideoList);
    MemoryModel tPartialUpdatedMemory = MemoryModel(
      id: 1,
      title: 'MyMemory',
      accountId: 1,
      videos: const [],
    );
    MemoryModel tFullyUpdatedMemory = MemoryModel(
      id: 1,
      title: 'MyMemory',
      accountId: 1,
      videos: tTobeAddedVideoList,
    );
    test('Should return failure if connection is not available', () async {
      Memory tMemory =
          Memory(id: null, title: 'MyMemory', accountId: 1, videos: const []);
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      // act
      final result = await memoryCreator.process(tMemory);
      //assert
      expect(
          result,
          equals(const Left(
              ConnectivityFailure(message: 'No internet connection'))));
    });
    test('Should return an updated Memory if call is succesfull', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(mockRemoteDataSource.postMemoryToAPI(memory: tDraftMemory))
          .thenAnswer((_) async => tPartialUpdatedMemory);

      when(mockVideoProcessingServices.addVideos(
              memoryId: tPartialUpdatedMemory.id, videos: tTobeAddedVideoList))
          .thenAnswer((_) async => tFullyUpdatedMemory);

      when(mockRemoteDataSource.getMemoryDetailsFromAPI(
              memoryId: tPartialUpdatedMemory.id))
          .thenAnswer((_) async => tFullyUpdatedMemory);
      // act
      final result = await memoryCreator.process(tDraftMemory);
      //assert
      expect(result, equals(Right(tFullyUpdatedMemory)));
    });
    test('Should return a Failure when not able to Post new memory', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(mockRemoteDataSource.postMemoryToAPI(memory: tDraftMemory))
          .thenThrow(ServerException());

      when(mockVideoProcessingServices.addVideos(
              memoryId: tPartialUpdatedMemory.id, videos: tTobeAddedVideoList))
          .thenAnswer((_) async => tFullyUpdatedMemory);

      when(mockRemoteDataSource.getMemoryDetailsFromAPI(
              memoryId: tPartialUpdatedMemory.id))
          .thenAnswer((_) async => tFullyUpdatedMemory);
      // act
      final result = await memoryCreator.process(tDraftMemory);
      //assert
      expect(
          result,
          equals(const Left(
              ServerFailure(message: 'Unable to Post new memory to API'))));
    });
    test('Should return a Failure when not able to Post Videos to new memory',
        () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(mockRemoteDataSource.postMemoryToAPI(memory: tDraftMemory))
          .thenAnswer((_) async => tPartialUpdatedMemory);

      when(mockVideoProcessingServices.addVideos(
              memoryId: tPartialUpdatedMemory.id, videos: tTobeAddedVideoList))
          .thenThrow(ServerException());

      when(mockRemoteDataSource.getMemoryDetailsFromAPI(
              memoryId: tPartialUpdatedMemory.id))
          .thenAnswer((_) async => tFullyUpdatedMemory);
      // act
      final result = await memoryCreator.process(tDraftMemory);
      //assert
      expect(
          result,
          equals(const Left(
              ServerFailure(message: 'Unable to Post Videos to API'))));
    });
    test(
        'Should return a Failure when not able to retrieve updated memory from API',
        () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(mockRemoteDataSource.postMemoryToAPI(memory: tDraftMemory))
          .thenAnswer((_) async => tPartialUpdatedMemory);

      when(mockVideoProcessingServices.addVideos(
              memoryId: tPartialUpdatedMemory.id, videos: tTobeAddedVideoList))
          .thenAnswer((_) async => tFullyUpdatedMemory);

      when(mockRemoteDataSource.getMemoryDetailsFromAPI(
              memoryId: tPartialUpdatedMemory.id))
          .thenThrow(ServerException());
      // act
      final result = await memoryCreator.process(tDraftMemory);
      //assert
      expect(
          result,
          equals(const Left(ServerFailure(
              message: 'Unable to Retrieve updated memory from API'))));
    });
  });
  group('MemoryUpdater', () {
    const List<Video> tTobeAddedVideoList = [
      Video(
        id: null,
        file: 'myNewPath',
        thumbnail: null,
        name: 'myNewVideo',
        memoryId: 1,
        thumbnailData: null,
      )
    ];

    const List<Video> tFinalVideoList = [
      Video(
        id: 2,
        file: 'myNewPath',
        thumbnail: null,
        name: 'myNewVideo',
        memoryId: 1,
        thumbnailData: null,
      )
    ];

    MemoryModel tDraftMemory = MemoryModel(
        id: 1, title: 'MyNewMemory', accountId: 1, videos: tTobeAddedVideoList);

    MemoryModel iInitialPresistedMemory = MemoryModel(
      id: 1,
      title: 'MyOldMemory',
      accountId: 1,
      videos: null,
    );

    MemoryModel tPartialUpdatedMemory = MemoryModel(
      id: 1,
      title: 'MyNewMemory',
      accountId: 1,
      videos: null,
    );

    MemoryModel tFullyUpdatedMemory = MemoryModel(
      id: 1,
      title: 'MyNewMemory',
      accountId: 1,
      videos: tFinalVideoList,
    );

    test('Should return failure if connection is not available', () async {
      Memory tMemory =
          Memory(id: null, title: 'MyMemory', accountId: 1, videos: const []);
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      // act
      final result = await memoryUpdater.process(tMemory);
      //assert
      expect(
          result,
          equals(const Left(
              ConnectivityFailure(message: 'No internet connection'))));
    });
    test('Should return an updated Memory if call is succesfull', () async {
      final getMemoryDetailsFromAPIResponses = [
        iInitialPresistedMemory,
        tFullyUpdatedMemory
      ];
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getMemoryDetailsFromAPI(
              memoryId: tDraftMemory.id))
          .thenAnswer(
              (_) async => getMemoryDetailsFromAPIResponses.removeAt(0));
      when(mockRemoteDataSource.patchUpdateMemoryToAPI(
              memory: anyNamed('memory')))
          .thenAnswer((_) async => tPartialUpdatedMemory);
      when(mockVideoProcessingServices.processVideoChanges(
              tDraftMemory, tPartialUpdatedMemory))
          .thenAnswer((_) async => tFullyUpdatedMemory);
      when(mockRemoteDataSource.getMemoryDetailsFromAPI(
              memoryId: tDraftMemory.id))
          .thenAnswer(
              (_) async => getMemoryDetailsFromAPIResponses.removeAt(0));

      // act
      final result = await memoryUpdater.process(tDraftMemory);
      // assert
      expect(result, equals(Right(tFullyUpdatedMemory)));
    });
    test(
        'Should return an update Failure if call is orginal memory retrival fails',
        () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getMemoryDetailsFromAPI(
              memoryId: tDraftMemory.id))
          .thenThrow(ServerException());
      when(mockRemoteDataSource.patchUpdateMemoryToAPI(
              memory: anyNamed('memory')))
          .thenAnswer((_) async => tPartialUpdatedMemory);
      when(mockVideoProcessingServices.processVideoChanges(
              tDraftMemory, tPartialUpdatedMemory))
          .thenAnswer((_) async => tFullyUpdatedMemory);
      when(mockRemoteDataSource.getMemoryDetailsFromAPI(
              memoryId: tDraftMemory.id))
          .thenThrow(ServerException());

      // act
      final result = await memoryUpdater.process(tDraftMemory);
      // assert
      expect(
          result,
          equals(const Left(ServerFailure(
              message: 'Unable to Retrieve previous memory from API'))));
    });
    test('Should return a Patch Failure if Patch call to update memory fails',
        () async {
      final getMemoryDetailsFromAPIResponses = [
        iInitialPresistedMemory,
        tFullyUpdatedMemory
      ];
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getMemoryDetailsFromAPI(
              memoryId: tDraftMemory.id))
          .thenAnswer(
              (_) async => getMemoryDetailsFromAPIResponses.removeAt(0));
      when(mockRemoteDataSource.patchUpdateMemoryToAPI(
              memory: anyNamed('memory')))
          .thenThrow(ServerException());
      when(mockVideoProcessingServices.processVideoChanges(
              tDraftMemory, tPartialUpdatedMemory))
          .thenAnswer((_) async => tFullyUpdatedMemory);
      when(mockRemoteDataSource.getMemoryDetailsFromAPI(
              memoryId: tDraftMemory.id))
          .thenAnswer(
              (_) async => getMemoryDetailsFromAPIResponses.removeAt(0));

      // act
      final result = await memoryUpdater.process(tDraftMemory);
      // assert
      expect(
          result,
          equals(const Left(ServerFailure(
              message: 'Unable to patch changes on memory to API'))));
    });
    test('Should return a Failure if updated memory retrival fails', () async {
      final getMemoryDetailsFromAPIResponses = [
        iInitialPresistedMemory,
      ];
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getMemoryDetailsFromAPI(
              memoryId: tDraftMemory.id))
          .thenAnswer(
              (_) async => getMemoryDetailsFromAPIResponses.removeAt(0));
      when(mockRemoteDataSource.patchUpdateMemoryToAPI(
              memory: anyNamed('memory')))
          .thenAnswer((_) async => tPartialUpdatedMemory);
      when(mockVideoProcessingServices.processVideoChanges(
              tDraftMemory, tPartialUpdatedMemory))
          .thenAnswer((_) async => tFullyUpdatedMemory);
      when(mockRemoteDataSource.getMemoryDetailsFromAPI(
              memoryId: tDraftMemory.id))
          .thenThrow(ServerException());

      // act
      final result = await memoryUpdater.process(tDraftMemory);
      // assert
      expect(
          result,
          equals(const Left(ServerFailure(
              message: 'Unable to Retrieve previous memory from API'))));
    });
  });
}
