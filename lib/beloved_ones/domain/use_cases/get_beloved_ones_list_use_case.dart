import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:griot_app/beloved_ones/domain/entities/beloved_one.dart';
import 'package:griot_app/beloved_ones/domain/repositories/beloved_one_repository.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/usecases/usecases.dart';

class GetBelovedOnesListUseCase implements UseCase<List<BelovedOne>, NoParams> {
  final BelovedOnesRepository repository;

  GetBelovedOnesListUseCase(this.repository);

  @override
  Future<Either<Failure, List<BelovedOne>>> call(NoParams params) async {
    return await repository.performGeBelovedOnesList();
  }
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
