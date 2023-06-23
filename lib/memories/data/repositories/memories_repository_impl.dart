import 'package:dartz/dartz.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/network/network_info.dart';
import 'package:griot_app/memories/data/data_source/memories_local_data_source.dart';
import 'package:griot_app/memories/data/data_source/memories_remote_data_source.dart';
import 'package:griot_app/memories/data/models/memory_model.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/domain/entities/video.dart';
import 'package:griot_app/memories/domain/repositories/memories_repository.dart';

class MemoriesRepositoryImpl implements MemoriesRepository {
  final NetworkInfo networkInfo;
  final MemoriesRemoteDataSource remoteDataSource;
  final MemoriesLocalDataSource localDataSource;

  MemoriesRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Memory>>> getMemoriesList() async {
    if (await networkInfo.isConnected) {
      try {
        final List<Memory> memories =
            await remoteDataSource.getMemoriesListFromAPI();
        return Right(memories);
      } on ServerException {
        return const Left(ServerFailure(message: 'Unable to retrieve data'));
      }
    } else {
      return const Left(ConnectivityFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Memory>> performGetMemoryDetails(
      {required int memoryId}) async {
    if (await networkInfo.isConnected) {
      try {
        final Memory memory =
            await remoteDataSource.getMemoryDetailsFromAPI(memoryId: memoryId);
        return Right(memory);
      } on ServerException {
        return const Left(ServerFailure(message: 'Unable to retrieve data'));
      }
    } else {
      return const Left(ConnectivityFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Memory>> performcreateMemory({
    required String? title,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final Memory memory =
            await remoteDataSource.postMemoryToAPI(title: title, videos: null);
        return Right(memory);
      } on ServerException {
        return const Left(ServerFailure(message: 'Unable to retrieve data'));
      }
    } else {
      return const Left(ConnectivityFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Video>?>> performGetVideoFromLibrary() async {
    try {
      final List<Video>? videosList =
          await localDataSource.getVideosFromLibraryFromDevice();
      return Right(videosList);
    } on MediaServiceException {
      return const Left(ServerFailure(message: 'Unable to retrieve data'));
    }
  }

  @override
  Future<Either<Failure, Memory>> performAddVideoFromLibraryToMemory(
      {required Memory memory}) async {
    if (!await networkInfo.isConnected) {
      return const Left(ConnectivityFailure(message: 'No internet connection'));
    }

    try {
      final List<Video>? videosList =
          await localDataSource.getVideosFromLibraryFromDevice();
      final MemoryModel updatedMemory = await remoteDataSource.postMemoryToAPI(
          title: memory.title, videos: videosList);
      return Right(updatedMemory);
    } on ServerException {
      return const Left(ServerFailure(message: 'Unable to POST data to API'));
    } on MediaServiceError {
      return const Left(MediaServiceFailure(
          message: 'Unable to retrieve media from library'));
    }
  }
}
