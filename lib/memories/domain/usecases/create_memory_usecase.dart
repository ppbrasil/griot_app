import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/usecases/usecases.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/domain/repositories/memories_repository.dart';

class CreateMemoriesUseCase implements UseCase<Memory, Params> {
  final MemoriesRepository repository;

  CreateMemoriesUseCase(this.repository);

  @override
  Future<Either<Failure, Memory>> call(Params params) async {
    return await repository.performcreateMemory(
      title: params.title,
    );
  }
}

class Params extends Equatable {
  final String title;

  const Params({
    required this.title,
  });

  @override
  List<Object> get props => [title];
}
