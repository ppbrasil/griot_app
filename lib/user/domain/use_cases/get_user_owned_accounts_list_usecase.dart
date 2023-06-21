import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/usecases/usecases.dart';
import 'package:griot_app/user/domain/repository/users_repository.dart';
import 'package:griot_app/accounts/domain/entities/account.dart';

class GetOwnedAccountsListUseCase implements UseCase<List<Account>, NoParams> {
  final UsersRepository repository;

  GetOwnedAccountsListUseCase(this.repository);

  @override
  Future<Either<Failure, List<Account>>> call(NoParams params) async {
    return await repository.performGetOwnedAccountsList();
  }
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object> get props => [];
}
