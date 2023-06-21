import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:griot_app/accounts/domain/entities/beloved_one.dart';
import 'package:griot_app/accounts/domain/repositories/accounts_repository.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/usecases/usecases.dart';

class GetBelovedOnesListUseCase implements UseCase<List<BelovedOne>, Params> {
  final AccountsRepository repository;

  GetBelovedOnesListUseCase(this.repository);

  @override
  Future<Either<Failure, List<BelovedOne>>> call(Params params) async {
    return await repository.performGetBelovedOnesList(
        accountId: params.accountId);
  }
}

class Params extends Equatable {
  final int accountId;

  const Params({required this.accountId});

  @override
  List<Object> get props => [];
}
