import 'package:griot_app/profile/domain/entities/profile.dart';

abstract class ProfilesRemoteDataSource {
  Future<Profile> getProfileDetailsFromAPI();
  Future<Profile> updateProfileDetailsOverAPI({
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
