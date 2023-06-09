import 'package:dartz/dartz.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';

abstract class MemoriesRepository {
  Future<Either<Failure, Memory>> performCreateDraftMemoryLocally(
      {required int accountId});

  Future<Either<Failure, List<Memory>>> getMemoriesList();

  Future<Either<Failure, Memory>> performGetMemoryDetails({
    required int memoryId,
  });

  Future<Either<Failure, Memory>> performAddVideoListFromLibraryToDraftMemory({
    required Memory memory,
  });

  Future<Either<Failure, Memory>> performCommitChangesToMemory({
    required Memory memory,
  });
}
