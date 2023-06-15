import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:griot_app/authentication/domain/entities/token.dart';
import 'package:griot_app/authentication/domain/repositories/auth_repository.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/usecases/usecases.dart';

class PerformLogin implements UseCase<Token, Params> {
  final AuthRepository repository;

  PerformLogin(this.repository);

  @override
  Future<Either<Failure, Token>> call(Params params) async {
    return await repository.login(
      username: params.username,
      password: params.password,
    );
  }
}

class Params extends Equatable {
  final String username;
  final String password;

  const Params({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];
}
