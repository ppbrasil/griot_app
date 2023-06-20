import 'package:griot_app/beloved_ones/domain/entities/beloved_one.dart';

class BelovedOneModel extends BelovedOne {
  const BelovedOneModel({
    required super.id,
    required super.profilePicture,
    required super.name,
    required super.middleName,
    required super.lastName,
    required super.birthDate,
    required super.gender,
    required super.language,
    required super.timeZone,
  });

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
