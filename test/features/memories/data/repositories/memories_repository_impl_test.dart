import 'package:dartz/dartz.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/network/network_info.dart';
import 'package:griot_app/memories/data/data_source/memories_local_data_source.dart';
import 'package:griot_app/memories/data/models/memory_model.dart';
import 'package:griot_app/memories/data/models/video_model.dart';
import 'package:griot_app/memories/data/repositories/memories_repository_impl.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';
import 'package:griot_app/memories/data/data_source/memories_remote_data_source.dart';

import 'memories_repository_impl_test.mocks.dart';

@GenerateMocks([MemoriesRemoteDataSource, MemoriesLocalDataSource, NetworkInfo])
void main() {
  late MemoriesRepositoryImpl repository;
  late MockMemoriesRemoteDataSource mockMemoriesRemoteDataSource;
  late MockMemoriesLocalDataSource mockMemoriesLocalDataSource;

  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockMemoriesRemoteDataSource = MockMemoriesRemoteDataSource();
    mockMemoriesLocalDataSource = MockMemoriesLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = MemoriesRepositoryImpl(
      remoteDataSource: mockMemoriesRemoteDataSource,
      localDataSource: mockMemoriesLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('performGetMemoryDetails', () {
    const tMemoryId = 1;
    const tAccount = 2;
    const tTitle = "Test Memory Title";
    MemoryModel tMemoryModel = MemoryModel(
      id: tMemoryId,
      accountId: tAccount,
      title: tTitle,
      videos: const [],
    );
    Memory tMemory = tMemoryModel;

    test('Should check connectivity when performGetMemoryDetails is called',
        () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockMemoriesRemoteDataSource.getMemoryDetailsFromAPI(
              memoryId: tMemoryId))
          .thenAnswer((_) async => tMemoryModel);
      // act
      repository.performGetMemoryDetails(memoryId: tMemoryId);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('Device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
          'Should return Entity when the call to remote data source is successful',
          () async {
        // arrange
        when(mockMemoriesRemoteDataSource.getMemoryDetailsFromAPI(
                memoryId: tMemoryId))
            .thenAnswer((_) async => tMemoryModel);
        // act
        final result =
            await repository.performGetMemoryDetails(memoryId: tMemoryId);
        // assert
        verify(mockNetworkInfo.isConnected);
        verify(mockMemoriesRemoteDataSource.getMemoryDetailsFromAPI(
            memoryId: tMemoryId));
        expect(result, equals(Right(tMemory)));
      });
      test(
          'Should return ServerFailure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockMemoriesRemoteDataSource.getMemoryDetailsFromAPI(
                memoryId: tMemoryId))
            .thenThrow(ServerException());
        // act
        final result =
            await repository.performGetMemoryDetails(memoryId: tMemoryId);
        // assert
        verify(mockMemoriesRemoteDataSource.getMemoryDetailsFromAPI(
            memoryId: tMemoryId));
        expect(
            result,
            equals(
                const Left(ServerFailure(message: 'Unable to retrieve data'))));
      });
    });

    group('Device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'Should return ConnectivityFailure when performGetMemoryDetails is called and device is offline',
        () async {
          // arrange
          // act
          final result =
              await repository.performGetMemoryDetails(memoryId: tMemoryId);
          // assert
          verify(mockNetworkInfo.isConnected);
          expect(
            result,
            equals(const Left(
                ConnectivityFailure(message: 'No internet connection'))),
          );
        },
      );

      test(
        'Should not call the remote data source when performGetMemoryDetails is called and device is offline',
        () async {
          // arrange
          // act
          await repository.performGetMemoryDetails(memoryId: tMemoryId);
          // assert
          verifyNever(mockMemoriesRemoteDataSource.getMemoryDetailsFromAPI(
              memoryId: tMemoryId));
        },
      );
    });
  });

  group('getMemoriesList', () {
    const tAccount1 = 1;
    const tTitle1 = "Test Memory Title 1";
    const tAccount2 = 2;
    const tTitle2 = "Test Memory Title 2";
    MemoryModel tMemoryModel1 =
        MemoryModel(id: 1, accountId: tAccount1, title: tTitle1, videos: []);
    MemoryModel tMemoryModel2 =
        MemoryModel(id: 2, accountId: tAccount2, title: tTitle2, videos: []);
    final List<MemoryModel> tMemoryModelList = [tMemoryModel1, tMemoryModel2];
    final List<Memory> tMemoryList = [tMemoryModel1, tMemoryModel2];

    test('Should check connectivity when getMemoriesList is called', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockMemoriesRemoteDataSource.getMemoriesListFromAPI())
          .thenAnswer((_) async => tMemoryModelList);
      // act
      repository.getMemoriesList();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('Device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
        'Should return Entity list when the call to remote data source is successful',
        () async {
          // arrange
          final tMemoryModelList = tMemoryList
              .map((e) => MemoryModel(
                    id: 1,
                    accountId: 1,
                    title: e.title,
                    videos: [],
                  ))
              .toList();
          when(mockMemoriesRemoteDataSource.getMemoriesListFromAPI())
              .thenAnswer((_) async => tMemoryModelList);
          // act
          final result = await repository.getMemoriesList();
          // assert
          final listResult = result.getOrElse(() =>
              []); // Retrieves the list if result is Right, or an empty list if it's a Left.
          Memory observed = tMemoryList[0];
          Memory theorical = listResult[0];

          //for (var i = 0; i < tMemoryList.length; i++) {
          expect(theorical, equals(observed));
        },
      );

      test(
          'Should return ServerFailure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockMemoriesRemoteDataSource.getMemoriesListFromAPI())
            .thenThrow(ServerException());
        // act
        final result = await repository.getMemoriesList();
        // assert
        verify(mockMemoriesRemoteDataSource.getMemoriesListFromAPI());
        expect(
            result,
            equals(
                const Left(ServerFailure(message: 'Unable to retrieve data'))));
      });
    });

    group('Device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'Should return ConnectivityFailure when getMemoriesList is called and device is offline',
        () async {
          // arrange
          // act
          final result = await repository.getMemoriesList();
          // assert
          verify(mockNetworkInfo.isConnected);
          expect(
            result,
            equals(const Left(
                ConnectivityFailure(message: 'No internet connection'))),
          );
        },
      );

      test(
        'Should not call the remote data source when getMemoriesList is called and device is offline',
        () async {
          // arrange
          // act
          await repository.getMemoriesList();
          // assert
          verifyNever(mockMemoriesRemoteDataSource.getMemoriesListFromAPI());
        },
      );
    });
  });

  group('performAddVideoFromLibraryToMemory', () {
    String tTitle = 'My Title';
    int tAccountId = 1;
    int tMemoryId = 1;

    const tVideo1 = VideoModel(
      file: '/videos/myVideo1',
      id: 1,
      name: 'Video Name 1',
      memoryId: null,
    );

    const List<VideoModel> tVideosList = [
      tVideo1,
    ];

    MemoryModel tMemoryModelBefore = MemoryModel(
      title: tTitle,
      videos: const [],
      accountId: tAccountId,
      id: tMemoryId,
    );
    MemoryModel tMemoryModelAfter = MemoryModel(
      title: tTitle,
      videos: tVideosList,
      accountId: tAccountId,
      id: tMemoryId,
    );

    test(
        'Should check connectivity when performAddVideoFromLibraryToMemory is called',
        () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(mockMemoriesLocalDataSource.getVideosFromLibraryFromDevice())
          .thenAnswer((_) async => tVideosList);

      when(mockMemoriesRemoteDataSource.postVideoToAPI(
              video: tVideo1, memoryId: tMemoryId))
          .thenAnswer((_) async => tVideo1);

      when(mockMemoriesRemoteDataSource.getMemoryDetailsFromAPI(
              memoryId: tMemoryId))
          .thenAnswer((_) async => tMemoryModelAfter);
      // act
      repository.performAddVideoFromLibraryToMemory(memory: tMemoryModelBefore);
      // assert
      verify(mockNetworkInfo.isConnected);
    });
    test(
        'Should return Videos list when the call to local data source is successful',
        () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(mockMemoriesLocalDataSource.getVideosFromLibraryFromDevice())
          .thenAnswer((_) async => tVideosList);

      when(mockMemoriesRemoteDataSource.postVideoToAPI(
              video: tVideo1, memoryId: tMemoryId))
          .thenAnswer((_) async => tVideo1);

      when(mockMemoriesRemoteDataSource.getMemoryDetailsFromAPI(
              memoryId: tMemoryId))
          .thenAnswer((_) async => tMemoryModelAfter);

      // act
      final result = await repository.performAddVideoFromLibraryToMemory(
          memory: tMemoryModelAfter);
      // assert
      verify(mockMemoriesLocalDataSource.getVideosFromLibraryFromDevice());
      verify(mockMemoriesRemoteDataSource.postVideoToAPI(
          video: tVideo1, memoryId: tMemoryId));
      verify(mockMemoriesRemoteDataSource.getMemoryDetailsFromAPI(
          memoryId: tMemoryId));
      expect(result, equals(Right(tMemoryModelAfter)));
    });

    /*
    test(
        'Should return ServerFailure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockMemoriesLocalDataSource.getVideosFromLibraryFromDevice())
          .thenThrow(MediaServiceException());
      // act
      final result = await repository.performGetVideoFromLibrary();
      // assert
      verify(mockMemoriesLocalDataSource.getVideosFromLibraryFromDevice());
      expect(
          result,
          equals(
              const Left(ServerFailure(message: 'Unable to retrieve data'))));
    });
  */
  });
}
