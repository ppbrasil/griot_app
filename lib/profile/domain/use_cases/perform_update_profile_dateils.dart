import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/usecases/usecases.dart';
import 'package:griot_app/profile/domain/entities/profile.dart';
import 'package:griot_app/profile/domain/repositories/profile_respository.dart';

class PerformUpdateProfileDetails implements UseCase<Profile, Params> {
  final ProfilesRepository repository;

  PerformUpdateProfileDetails(this.repository);

  @override
  Future<Either<Failure, Profile>> call(Params params) async {
    return await repository.performUpdateProfileDetails(
      profilePicture: params.profilePicture,
      name: params.name,
      middleName: params.middleName,
      lastName: params.lastName,
      birthDate: params.birthDate,
      gender: params.gender,
      language: params.language,
      timeZone: params.timeZone,
    );
  }
}

class Params extends Equatable {
  final String? profilePicture;
  final String? name;
  final String? middleName;
  final String? lastName;
  final DateTime? birthDate;
  final String? gender;
  final String? language;
  final String? timeZone;

  const Params({
    this.profilePicture,
    this.name,
    this.middleName,
    this.lastName,
    this.birthDate,
    this.gender,
    this.language,
    this.timeZone,
  });

  @override
  List<Object?> get props => [
        profilePicture,
        name,
        middleName,
        lastName,
        birthDate,
        gender,
        language,
        timeZone
      ];
}
