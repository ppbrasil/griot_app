import 'package:dartz/dartz.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/network/network_info.dart';
import 'package:griot_app/memories/data/data_source/memories_local_data_source.dart';
import 'package:griot_app/memories/data/models/memory_model.dart';
import 'package:griot_app/memories/data/models/video_model.dart';
import 'package:griot_app/memories/data/repositories/memories_repository_impl.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/domain/entities/video.dart';
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
  });

  group('performAddVideoListFromLibraryToDraftMemory', () {
    const tVideo1 = Video(
      file: '/videos/myVideo1',
      thumbnail: 'myThumbnail 1',
      id: 1,
      name: 'Video Name 1',
      memoryId: null,
    );

    const tVideo2 = VideoModel(
      file: '/videos/myVideo2',
      thumbnail: 'myThumbnail 2',
      id: 2,
      name: 'Video Name 2',
      memoryId: null,
    );

    const List<Video> tInitialVideoList = [tVideo1];
    const List<VideoModel> tVideoListToBeAdded = [tVideo2];
    const List<Video> tFinalVideoList = [tVideo1, tVideo2];

    Memory tInitialMemory = Memory(
      id: 1,
      title: "MyTitle",
      accountId: 1,
      videos: tInitialVideoList,
    );

    Memory tFinalMemory = Memory(
      id: 1,
      title: "MyTitle",
      accountId: 1,
      videos: tFinalVideoList,
    );

    test(
        'Should return a Memory with an updated Videos list when the call to local data source is successful',
        () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockMemoriesLocalDataSource.getVideosFromLibraryFromDevice())
          .thenAnswer((_) async => tVideoListToBeAdded);

      // act
      final result =
          await repository.performAddVideoListFromLibraryToDraftMemory(
        memory: tInitialMemory,
      );

      // assert
      verify(mockMemoriesLocalDataSource.getVideosFromLibraryFromDevice());

      expect(result, equals(Right(tFinalMemory)));
    });
  });

  group('performCreateDraftMemoryLocally', () {
    int tAccountId = 1;
    Memory tMemory = Memory(
      id: null,
      title: '',
      accountId: tAccountId,
      videos: const [],
    );

    test(
        'Should check connectivity when performRetrieveVideoListFromLibrary is called',
        () async {
      // arrange
      // act
      final result = await repository.performCreateDraftMemoryLocally(
          accountId: tAccountId);
      // assert
      expect(result, equals(Right(tMemory)));
    });
  });

  group('performCommitChangesToMemory', () {
    int tAccountId = 1;
    int tMemoryId = 1;
    String oldTitle = 'OldTitle';
    String newTtile = 'NewTitle';

    const tVideoModel1 = VideoModel(
      file: 'https://griot-memories-data.s3.amazonaws.com/videos/78-14021.mp4',
      //thumbnail: 'myThumbnail 1',
      id: null,
      name: 'Video Name 1',
      memoryId: 1,
    );

    const tVideoModel2 = VideoModel(
      file: 'https://griot-memories-data.s3.amazonaws.com/videos/78-14022.mp4',
      //thumbnail: 'myThumbnail 2',
      id: null,
      name: 'Video Name 2',
      memoryId: null,
    );
    const tVSavedVideoModel1 = VideoModel(
      file: 'https://griot-memories-data.s3.amazonaws.com/videos/78-14021.mp4',
      //thumbnail: 'myThumbnail 1',
      id: 1,
      name: 'Video Name 1',
      memoryId: null,
    );

    const tVSavedVideoModel2 = VideoModel(
      file: 'https://griot-memories-data.s3.amazonaws.com/videos/78-14022.mp4',
      //thumbnail: 'myThumbnail 2',
      id: 2,
      name: 'Video Name 2',
      memoryId: null,
    );

    List<VideoModel> tVideoModelListToBeAdded = [tVideoModel1, tVideoModel2];
    List<VideoModel> tVideoModelListAdded = [
      tVSavedVideoModel1,
      tVSavedVideoModel2
    ];

    Memory tMemoryDraftNoVideo = Memory(
      id: null,
      title: oldTitle,
      accountId: tAccountId,
      videos: null,
    );

    Memory tMemoryDraftWithNewVideos = Memory(
      id: null,
      title: oldTitle,
      accountId: tAccountId,
      videos: tVideoModelListToBeAdded,
    );

    MemoryModel tMemoryModelNoVideo = MemoryModel(
      id: tMemoryId,
      title: oldTitle,
      accountId: tAccountId,
      videos: null,
    );

    MemoryModel tMemoryModelWithVideo = MemoryModel(
      id: tMemoryId,
      title: oldTitle,
      accountId: tAccountId,
      videos: tVideoModelListAdded,
    );

    MemoryModel tMemoryModelWitVideoOne = MemoryModel(
      id: tMemoryId,
      title: oldTitle,
      accountId: tAccountId,
      videos: const [tVSavedVideoModel1],
    );
    MemoryModel tPartialupdatedMemory = MemoryModel(
      id: tMemoryId,
      title: newTtile,
      accountId: tAccountId,
      videos: const [tVSavedVideoModel1],
    );

    MemoryModel tMemoryModelWitVideoTwo = MemoryModel(
      id: tMemoryId,
      title: newTtile,
      accountId: tAccountId,
      videos: const [tVSavedVideoModel2],
    );

    group('offline', () {
      test('Should return a ConnectivityFailure when offline', () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(mockMemoriesRemoteDataSource.postMemoryToAPI(
                memory: tMemoryDraftNoVideo))
            .thenAnswer((_) async => tMemoryModelNoVideo);

        // act
        final result = await repository.performCommitChangesToMemory(
          memory: tMemoryDraftNoVideo,
        );

        // assert
        expect(
            result,
            equals(const Left(
                ConnectivityFailure(message: 'No internet connection'))));
      });
    });
    group('Online and Memory w/ NO ID', () {
      test(
          'Should return a new Memory whithout vidos when a MemoryDraft(no Id) with no video is passed to remotedatasource',
          () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockMemoriesRemoteDataSource.postMemoryToAPI(
                memory: tMemoryDraftNoVideo))
            .thenAnswer((_) async => tMemoryModelNoVideo);
        when(mockMemoriesRemoteDataSource.getMemoryDetailsFromAPI(
                memoryId: tMemoryModelNoVideo.id))
            .thenAnswer((_) async => tMemoryModelNoVideo);
        // act
        final result = await repository.performCommitChangesToMemory(
          memory: tMemoryDraftNoVideo,
        );
        // assert
        verify(mockMemoriesRemoteDataSource.postMemoryToAPI(
          memory: tMemoryDraftNoVideo,
        ));
        verifyNever(mockMemoriesRemoteDataSource.postVideoToAPI(
          memoryId: anyNamed('memoryId'),
          video: anyNamed('video'),
        ));
        expect(result, equals(Right(tMemoryModelNoVideo)));
      });
      test(
          'Should return a new Memory with videos when a MemoryDraft(no Id) with no id is passed to remotedatasource',
          () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockMemoriesRemoteDataSource.postMemoryToAPI(
                memory: tMemoryDraftWithNewVideos))
            .thenAnswer((_) async => tMemoryModelNoVideo);
        when(mockMemoriesRemoteDataSource.postVideoToAPI(
                video: tVideoModel1, memoryId: tMemoryId))
            .thenAnswer((_) async => tVSavedVideoModel1);
        when(mockMemoriesRemoteDataSource.postVideoToAPI(
                video: tVideoModel2, memoryId: tMemoryId))
            .thenAnswer((_) async => tVSavedVideoModel2);
        when(mockMemoriesRemoteDataSource.getMemoryDetailsFromAPI(
                memoryId: tMemoryId))
            .thenAnswer((_) async => tMemoryModelWithVideo);

        // act
        final result = await repository.performCommitChangesToMemory(
          memory: tMemoryDraftWithNewVideos,
        );

        // assert
        verify(mockMemoriesRemoteDataSource.postMemoryToAPI(
          memory: tMemoryDraftWithNewVideos,
        ));
        expect(result, equals(Right(tMemoryModelWithVideo)));
      });
    });
    group('Online and Memory HAVING ID', () {
      test(
          'Should return an updated Memory when a MemoryDraftw/ID is passed to remotedatasource w/ new content',
          () async {
        // arrange
        var answerForGetMemoryDetails = [
          tMemoryModelWitVideoOne,
          tMemoryModelWitVideoTwo
        ];

        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        when(mockMemoriesRemoteDataSource.getMemoryDetailsFromAPI(
                memoryId: tMemoryId))
            .thenAnswer((_) async => answerForGetMemoryDetails.removeAt(0));

        when(mockMemoriesRemoteDataSource.patchUpdateMemoryToAPI(
                memory: tPartialupdatedMemory))
            .thenAnswer((_) async => tPartialupdatedMemory);

        when(mockMemoriesRemoteDataSource.deleteVideoFromAPI(
                videoId: tMemoryModelWitVideoOne.videos!.first.id!))
            .thenAnswer((_) async => 0);

        when(mockMemoriesRemoteDataSource.postVideoToAPI(
          memoryId: tMemoryId,
          video: tVideoModel2,
        )).thenAnswer((_) async => tVSavedVideoModel2);

        // act
        final result = await repository.performCommitChangesToMemory(
            memory: tMemoryModelWitVideoTwo);
        // assert
        expect(result, equals(Right(tMemoryModelWitVideoTwo)));
      });
    });
  });
}
