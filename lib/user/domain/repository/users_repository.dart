import 'package:dartz/dartz.dart';
import 'package:griot_app/accounts/domain/entities/account.dart';
import 'package:griot_app/core/error/failures.dart';

abstract class UsersRepository {
  Future<Either<Failure, List<Account>>> performGetOwnedAccountsList();
  Future<Either<Failure, List<Account>>> performGetBelovedAccountsList();
}
