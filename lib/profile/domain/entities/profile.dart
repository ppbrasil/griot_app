import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final int? id;
  final String? profilePicture;
  final String? name;
  final String? middleName;
  final String? lastName;
  final DateTime? birthDate;
  final String? gender;
  final String? language;
  final String? timeZone;

  const Profile({
    this.id,
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
        id,
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
