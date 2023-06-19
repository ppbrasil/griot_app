import 'package:dartz/dartz.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/profile/domain/entities/profile.dart';

abstract class ProfilesRepository {
  Future<Either<Failure, Profile>> performGetProfileDetails();
  Future<Either<Failure, Profile>> performUpdateProfileDetails({
    final String? profilePicture,
    final String? name,
    final String? middleName,
    final String? lastName,
    final DateTime? birthDate,
    final String? gender,
    final String? language,
    final String? timeZone,
  });
}
