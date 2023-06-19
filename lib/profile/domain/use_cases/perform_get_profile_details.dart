import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/usecases/usecases.dart';
import 'package:griot_app/profile/domain/entities/profile.dart';
import 'package:griot_app/profile/domain/repositories/profile_respository.dart';

class PerformGetProfileDetails implements UseCase<Profile, NoParams> {
  final ProfilesRepository repository;

  PerformGetProfileDetails(this.repository);

  @override
  Future<Either<Failure, Profile>> call(NoParams params) async {
    return await repository.performGetProfileDetails();
  }
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
