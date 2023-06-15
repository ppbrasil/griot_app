import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/usecases/usecases.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/domain/repositories/memories_repository.dart';

class GetMemoriesUseCase implements UseCase<Memory, Params> {
  final MemoriesRepository repository;

  GetMemoriesUseCase(this.repository);

  @override
  Future<Either<Failure, Memory>> call(Params params) async {
    return await repository.performGetMemoryDetails(
      memoryId: params.memoryId,
    );
  }
}

class Params extends Equatable {
  final int memoryId;

  const Params({
    required this.memoryId,
  });

  @override
  List<Object> get props => [memoryId];
}
