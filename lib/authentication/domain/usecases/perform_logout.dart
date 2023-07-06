import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:griot_app/authentication/domain/repositories/auth_repository.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/usecases/usecases.dart';

class PerformLogout implements UseCase<bool, NoParams> {
  final AuthRepository repository;

  PerformLogout(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.logout();
  }
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object> get props => [];
}
