import 'package:griot_app/accounts/domain/entities/beloved_one.dart';

class BelovedOneModel extends BelovedOne {
  const BelovedOneModel({
    required int id,
    String? profilePicture,
    String? name,
    String? middleName,
    required String lastName,
    DateTime? birthDate,
    required String gender,
    required String language,
    required String timeZone,
  }) : super(
            id: id,
            profilePicture: profilePicture,
            name: name,
            middleName: middleName,
            lastName: lastName,
            birthDate: birthDate,
            gender: gender,
            language: language,
            timeZone: timeZone);

  factory BelovedOneModel.fromJson(Map<String, dynamic> json) {
    return BelovedOneModel(
      id: json['id'] as int,
      profilePicture: json['profile_picture'] as String?,
      name: json['name'] as String?,
      middleName: json['middle_name'] as String?,
      lastName: json['last_name'] as String,
      birthDate: json['birth_date'] != null
          ? DateTime.parse(json['birth_date'] as String)
          : null,
      gender: json['gender'] as String,
      language: json['language'] as String,
      timeZone: json['timezone'] as String,
    );
  }
}
