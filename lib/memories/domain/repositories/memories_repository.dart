import 'package:dartz/dartz.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';

abstract class MemoriesRepository {
  Future<Either<Failure, List<Memory>>> getMemoriesList();
  Future<Either<Failure, Memory>> performGetMemoryDetails({int memoryId});
  Future<Either<Failure, Memory>> performcreateMemory({String title});

/*
  Future<Either<Failure, Memory>> updateMemory();
  Future<Either<Failure, Memory>> deleteMemory();
*/
}
