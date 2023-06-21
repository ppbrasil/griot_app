import 'package:dartz/dartz.dart';
import 'package:griot_app/accounts/domain/entities/account.dart';
import 'package:griot_app/accounts/domain/entities/beloved_one.dart';
import 'package:griot_app/core/error/failures.dart';

abstract class AccountsRepository {
  Future<Either<Failure, List<BelovedOne>>> performGetBelovedOnesList(
      {required int? accountId});
  Future<Either<Failure, Account>> performGetAccountDetails(
      {required int? accountId});
  Future<Either<Failure, BelovedOne>> performGetBelovedOneDetails(
      {required int? belovedOneId});
}
