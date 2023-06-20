import 'package:griot_app/profile/domain/entities/profile.dart';

class BelovedOne extends Profile {
  const BelovedOne({
    int? id,
    String? profilePicture,
    String? name,
    String? middleName,
    String? lastName,
    DateTime? birthDate,
    String? gender,
    String? language,
    String? timeZone,
  }) : super(
          id: id,
          profilePicture: profilePicture,
          name: name,
          middleName: middleName,
          lastName: lastName,
          birthDate: birthDate,
          gender: gender,
          language: language,
          timeZone: timeZone,
        );
}
