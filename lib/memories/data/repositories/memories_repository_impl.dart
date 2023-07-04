import 'package:dartz/dartz.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/network/network_info.dart';
import 'package:griot_app/memories/data/data_source/memories_local_data_source.dart';
import 'package:griot_app/memories/data/data_source/memories_remote_data_source.dart';
import 'package:griot_app/memories/data/models/memory_model.dart';
import 'package:griot_app/memories/data/models/video_model.dart';
import 'package:griot_app/memories/data/repositories/memory_processor.dart';
import 'package:griot_app/memories/data/repositories/video_processor.dart';
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
      } on InvalidTokenException {
        return const Left(ServerFailure(message: 'Token rejected'));
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
      } on InvalidTokenException {
        return const Left(ServerFailure(message: 'Token rejected'));
      }
    } else {
      return const Left(ConnectivityFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Memory>> performcreateMemory({
    required Memory memory,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final Memory savedMemory =
            await remoteDataSource.postMemoryToAPI(memory: memory);
        return Right(savedMemory);
      } on ServerException {
        return const Left(ServerFailure(message: 'Unable to retrieve data'));
      } on InvalidTokenException {
        return const Left(ServerFailure(message: 'Token rejected'));
      }
    } else {
      return const Left(ConnectivityFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Memory>> performAddVideoFromLibraryToMemory(
      {required Memory memory}) async {
    if (!await networkInfo.isConnected) {
      return const Left(ConnectivityFailure(message: 'No internet connection'));
    }

    try {
      final List<VideoModel>? videosList =
          await localDataSource.getVideosFromLibraryFromDevice();
      if (videosList == null) {
        return Right(memory);
      }

      for (final video in videosList) {
        await remoteDataSource.postVideoToAPI(
            video: video, memoryId: memory.id!);
      }

      final MemoryModel updatedMemory =
          await remoteDataSource.getMemoryDetailsFromAPI(memoryId: memory.id!);

      return Right(updatedMemory);
    } on ServerException {
      return const Left(ServerFailure(message: 'Unable to POST data to API'));
    } on InvalidTokenException {
      return const Left(ServerFailure(message: 'Token rejected'));
    } on MediaServiceException {
      return const Left(MediaServiceFailure(
          message: 'Unable to retrieve media from library'));
    }
  }

  @override
  Future<Either<Failure, Memory>> performCreateDraftMemoryLocally(
      {required int accountId}) async {
    return Right(Memory(
      accountId: accountId,
      id: null,
      title: '',
      videos: const [],
    ));
  }

  @override
  Future<Either<Failure, Memory>> performAddVideoListFromLibraryToDraftMemory(
      {required Memory memory}) async {
    try {
      final List<VideoModel>? videosList =
          await localDataSource.getVideosFromLibraryFromDevice();
      if (videosList == null) {
        return Right(memory);
      }

      List<Video> mergedVideoList = [];
      if (memory.videos != null) {
        mergedVideoList.addAll(memory.videos!);
      }
      mergedVideoList.addAll(videosList);

      Memory updatedMemory = memory.copyWith(videos: mergedVideoList);

      return Right(updatedMemory);
    } on InvalidTokenException {
      return const Left(ServerFailure(message: 'Token rejected'));
    } on MediaServiceException {
      return const Left(MediaServiceFailure(
          message: 'Unable to retrieve media from library'));
    }
  }

  @override
  Future<Either<Failure, Memory>> performCommitChangesToMemory({
    required Memory memory,
  }) async {
    MemoryProcessor memoryProcessor;
    VideoProcessingService videoProcessingService = VideoProcessingService(
      remoteDataSource: remoteDataSource,
    );

    // Check if it's an existing or new memory
    if (memory.id == null) {
      memoryProcessor = MemoryCreator(
        networkInfo: networkInfo,
        remoteDataSource: remoteDataSource,
        videoProcessingService: videoProcessingService,
      );
    } else {
      memoryProcessor = MemoryUpdater(
        networkInfo: networkInfo,
        remoteDataSource: remoteDataSource,
        videoProcessingService: videoProcessingService,
      );
    }

    return memoryProcessor.process(memory);
  }

  @override
  Future<Either<Failure, Memory>> performUpdateMemory(
      {required Memory memory}) async {
    if (!await networkInfo.isConnected) {
      return const Left(ConnectivityFailure(message: 'No internet connection'));
    }
    try {
      final Memory updatedMemory =
          await remoteDataSource.patchUpdateMemoryToAPI(memory: memory);
      return Right(updatedMemory);
    } on InvalidTokenException {
      return const Left(ServerFailure(message: 'Token rejected'));
    } on ServerException {
      return const Left(ServerFailure(message: 'Unable to update memory'));
    }
  }
}
