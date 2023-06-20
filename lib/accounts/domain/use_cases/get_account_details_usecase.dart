import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:griot_app/accounts/domain/entities/account.dart';
import 'package:griot_app/accounts/domain/repository/accounts_repository.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/usecases/usecases.dart';

class GetAccountsDetails implements UseCase<Account, Params> {
  final AccountsRepository repository;

  GetAccountsDetails(this.repository);

  @override
  Future<Either<Failure, Account>> call(Params params) async {
    return await repository.performGetAccountDetails(
      accountId: params.accountId,
    );
  }
}

class Params extends Equatable {
  final int accountId;

  const Params({
    required this.accountId,
  });

  @override
  List<Object> get props => [accountId];
}
