import 'package:dartz/dartz.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/network/network_info.dart';
import 'package:griot_app/memories/data/models/memory_model.dart';
import 'package:griot_app/memories/data/repositories/memories_repository_impl.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';
import 'package:griot_app/memories/data/data_source/memories_remote_data_source.dart';

import 'memories_repository_impl_test.mocks.dart';

@GenerateMocks([MemoriesRemoteDataSource, NetworkInfo])
void main() {
  late MemoriesRepositoryImpl repository;
  late MockMemoriesRemoteDataSource mockMemoriesRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late int tMemoryId;

  setUp(() {
    mockMemoriesRemoteDataSource = MockMemoriesRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = MemoriesRepositoryImpl(
      remoteDataSource: mockMemoriesRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('performGetMemoryDetails', () {
    const tMemoryId = 1;
    const tAccount = 2;
    const tTitle = "Test Memory Title";
    const tMemoryModel = MemoryModel(account: tAccount, title: tTitle);
    const Memory tMemory = tMemoryModel;

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
        expect(result, equals(const Right(tMemory)));
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
    const tMemoryModel1 = MemoryModel(account: tAccount1, title: tTitle1);
    const tMemoryModel2 = MemoryModel(account: tAccount2, title: tTitle2);
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
              .map((e) => MemoryModel(account: 1, title: e.title))
              .toList();
          when(mockMemoriesRemoteDataSource.getMemoriesListFromAPI())
              .thenAnswer((_) async => tMemoryModelList);
          // act
          final result = await repository.getMemoriesList();
          // assert
          final listResult = result.getOrElse(() =>
              []); // Retrieves the list if result is Right, or an empty list if it's a Left.
          for (var i = 0; i < tMemoryList.length; i++) {
            expect(listResult[i], equals(tMemoryList[i]));
          }
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

  group('performCreateMemory', () {
    const tTitle = "New Memory Title";
    const tAccount = 2;
    const tMemoryModel = MemoryModel(account: tAccount, title: tTitle);
    const Memory tMemory = tMemoryModel;

    test('Should check connectivity when performCreateMemory is called',
        () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockMemoriesRemoteDataSource.postMemoryToAPI(title: tTitle))
          .thenAnswer((_) async => tMemoryModel);
      // act
      repository.performcreateMemory(title: tTitle);
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
          when(mockMemoriesRemoteDataSource.postMemoryToAPI(title: tTitle))
              .thenAnswer((_) async => tMemoryModel);
          // act
          final result = await repository.performcreateMemory(title: tTitle);
          // assert
          verify(mockNetworkInfo.isConnected);
          verify(mockMemoriesRemoteDataSource.postMemoryToAPI(title: tTitle));
          expect(result, equals(const Right(tMemory)));
        },
      );

      test(
        'Should return ServerFailure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockMemoriesRemoteDataSource.postMemoryToAPI(title: tTitle))
              .thenThrow(ServerException());
          // act
          final result = await repository.performcreateMemory(title: tTitle);
          // assert
          verify(mockMemoriesRemoteDataSource.postMemoryToAPI(title: tTitle));
          expect(
            result,
            equals(
                const Left(ServerFailure(message: 'Unable to retrieve data'))),
          );
        },
      );
    });

    group('Device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'Should return ConnectivityFailure when performCreateMemory is called and device is offline',
        () async {
          // arrange
          // act
          final result = await repository.performcreateMemory(title: tTitle);
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
        'Should not call the remote data source when performCreateMemory is called and device is offline',
        () async {
          // arrange
          // act
          await repository.performcreateMemory(title: tTitle);
          // assert
          verifyNever(
              mockMemoriesRemoteDataSource.postMemoryToAPI(title: tTitle));
        },
      );
    });
  });
}
