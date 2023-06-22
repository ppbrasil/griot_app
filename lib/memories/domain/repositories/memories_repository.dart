import 'package:dartz/dartz.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/domain/entities/video.dart';

abstract class MemoriesRepository {
  Future<Either<Failure, List<Memory>>> getMemoriesList();
  Future<Either<Failure, Memory>> performGetMemoryDetails(
      {required int memoryId});
  Future<Either<Failure, Memory>> performcreateMemory({required String title});
  Future<Either<Failure, List<Video>?>> performGetVideoFromLibrary();
}
