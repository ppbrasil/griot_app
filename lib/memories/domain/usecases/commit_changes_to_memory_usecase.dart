import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/usecases/usecases.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/domain/repositories/memories_repository.dart';

class CommitChangesToMemoryUseCase implements UseCase<Memory, Params> {
  final MemoriesRepository repository;

  CommitChangesToMemoryUseCase(this.repository);

  @override
  Future<Either<Failure, Memory>> call(Params params) async {
    return await repository.performCommitChangesToMemory(
      memory: params.memory,
    );
  }
}

class Params extends Equatable {
  final Memory memory;

  const Params({
    required this.memory,
  });

  @override
  List<Object> get props => [memory];
}
