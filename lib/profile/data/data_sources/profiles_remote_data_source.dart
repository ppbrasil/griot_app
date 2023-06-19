import 'package:griot_app/profile/domain/entities/profile.dart';

abstract class ProfilesRemoteDataSource {
  Future<Profile> performGetProfileDetails();
  Future<Profile> performUpdateProfileDetails({
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
