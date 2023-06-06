import 'package:dartz/dartz.dart';
import 'package:griot_app/authentication/data/entities/token.dart';
import 'package:griot_app/authentication/domain/repositories/auth_repository.dart';
import 'package:griot_app/core/error/failures.dart';

class PerformLogin{
  final AuthRepository repository;

  PerformLogin(this.repository);

  Future<Either<Failure, Token>> execute({required String email, required String password}) async {
    return await repository.performLogin(email, password);
  }
}