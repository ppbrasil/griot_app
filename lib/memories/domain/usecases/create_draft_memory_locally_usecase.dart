import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/usecases/usecases.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/domain/repositories/memories_repository.dart';

class CreateDraftMemoryLocallyUseCase implements UseCase<Memory, Params> {
  final MemoriesRepository repository;

  CreateDraftMemoryLocallyUseCase(this.repository);

  @override
  Future<Either<Failure, Memory>> call(Params params) async {
    return await repository.performCreateDraftMemoryLocally(
        accountId: params.accountId);
  }
}

class Params extends Equatable {
  final int accountId;
  const Params({required this.accountId});

  @override
  List<Object> get props => [];
}
