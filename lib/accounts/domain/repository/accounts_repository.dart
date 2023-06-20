import 'package:dartz/dartz.dart';
import 'package:griot_app/accounts/domain/entities/account.dart';
import 'package:griot_app/core/error/failures.dart';

abstract class AccountsRepository {
  Future<Either<Failure, Account>> performGetAccountDetails({int? accountId});
}
