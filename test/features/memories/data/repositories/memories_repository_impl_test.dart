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
      networkinfo: mockNetworkInfo,
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
}
