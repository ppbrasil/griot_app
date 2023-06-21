import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:griot_app/accounts/domain/entities/beloved_one.dart';
import 'package:griot_app/accounts/domain/repositories/accounts_repository.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/usecases/usecases.dart';

class GetBelovedOneDetailsUseCase implements UseCase<BelovedOne, Params> {
  final AccountsRepository repository;

  GetBelovedOneDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, BelovedOne>> call(Params params) async {
    return await repository.performGetBelovedOneDetails(
        belovedOneId: params.belovedOneId);
  }
}

class Params extends Equatable {
  final int belovedOneId;

  const Params({
    required this.belovedOneId,
  });

  @override
  List<Object> get props => [belovedOneId];
}
