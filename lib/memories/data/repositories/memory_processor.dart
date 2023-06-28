import 'package:dartz/dartz.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/network/network_info.dart';
import 'package:griot_app/memories/data/data_source/memories_remote_data_source.dart';
import 'package:griot_app/memories/data/models/memory_model.dart';
import 'package:griot_app/memories/data/repositories/video_processor.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';

abstract class MemoryProcessor {
  Future<Either<Failure, Memory>> process(Memory memory);
}

class MemoryCreator implements MemoryProcessor {
  final NetworkInfo networkInfo;
  final MemoriesRemoteDataSource remoteDataSource;
  final VideoProcessingService videoProcessingService;

  MemoryCreator(
      {required this.networkInfo,
      required this.remoteDataSource,
      required this.videoProcessingService});

  @override
  Future<Either<Failure, Memory>> process(Memory memory) async {
    if (!await networkInfo.isConnected) {
      return const Left(ConnectivityFailure(message: 'No internet connection'));
    }
    late MemoryModel postedMemory;
    late MemoryModel commitedMemory;

    try {
      postedMemory = await remoteDataSource.postMemoryToAPI(memory: memory);
    } on Exception {
      return const Left(
          ServerFailure(message: 'Unable to Post new memory to API'));
    }

    try {
      if (memory.videos != null) {
        await videoProcessingService.addVideos(
            memoryId: postedMemory.id!, videos: memory.videos!);
      }
    } on Exception {
      return const Left(ServerFailure(message: 'Unable to Post Videos to API'));
    }

    try {
      commitedMemory = await remoteDataSource.getMemoryDetailsFromAPI(
          memoryId: postedMemory.id!);
    } on Exception {
      return const Left(
          ServerFailure(message: 'Unable to Retrieve updated memory from API'));
    }

    return Right(commitedMemory);
  }
}

class MemoryUpdater implements MemoryProcessor {
  final NetworkInfo networkInfo;
  final MemoriesRemoteDataSource remoteDataSource;
  final VideoProcessingService videoProcessingService;

  MemoryUpdater(
      {required this.networkInfo,
      required this.remoteDataSource,
      required this.videoProcessingService});

  @override
  Future<Either<Failure, Memory>> process(Memory memory) async {
    if (!await networkInfo.isConnected) {
      return const Left(ConnectivityFailure(message: 'No internet connection'));
    }

    late MemoryModel originalMemoryOnServer;
    late Memory partialUpdatedMemory;
    late Memory updatedMemory;

    try {
      originalMemoryOnServer =
          await remoteDataSource.getMemoryDetailsFromAPI(memoryId: memory.id!);
    } on Exception {
      return const Left(ServerFailure(
          message: 'Unable to Retrieve previous memory from API'));
    }

    partialUpdatedMemory = Memory(
      accountId: memory.accountId,
      id: memory.id!,
      title: memory.title,
      videos: originalMemoryOnServer.videos,
    );

    try {
      partialUpdatedMemory = await remoteDataSource.patchUpdateMemoryToAPI(
          memory: partialUpdatedMemory);
    } on Exception {
      return const Left(
          ServerFailure(message: 'Unable to patch changes on memory to API'));
    }

    videoProcessingService.processVideoChanges(
        partialUpdatedMemory, originalMemoryOnServer);

    try {
      updatedMemory =
          await remoteDataSource.getMemoryDetailsFromAPI(memoryId: memory.id!);
    } on Exception {
      return const Left(
          ServerFailure(message: 'Unable to Retrieve updated memory from API'));
    }

    return Right(updatedMemory);
  }
}
