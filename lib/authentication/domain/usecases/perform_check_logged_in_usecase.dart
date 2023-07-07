import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:griot_app/authentication/domain/entities/token.dart';
import 'package:griot_app/authentication/domain/repositories/auth_repository.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/usecases/usecases.dart';

class CheckLoggedInUseCase implements UseCase<Token, NoParams> {
  final AuthRepository repository;

  CheckLoggedInUseCase(this.repository);

  @override
  Future<Either<Failure, Token>> call(NoParams noParams) async {
    return await repository.performCheckLoggedIn();
  }
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object> get props => [];
}
