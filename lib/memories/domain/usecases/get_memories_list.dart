import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/usecases/usecases.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/domain/repositories/memories_repository.dart';

class GetMemoriesList implements UseCase<List<Memory>, NoParams> {
  final MemoriesRepository repository;

  GetMemoriesList(this.repository);

  @override
  Future<Either<Failure, List<Memory>>> call(NoParams params) async {
    return await repository.getMemoriesList();
  }
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
