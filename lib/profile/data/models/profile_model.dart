import 'package:griot_app/profile/domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
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

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as int,
      profilePicture: json['profile_picture'] as String?,
      name: json['name'] as String,
      middleName: json['middle_name'] as String?,
      lastName: json['last_name'] as String,
      birthDate: DateTime.parse(json['birth_date'] as String),
      gender: json['gender'] as String,
      language: json['language'] as String,
      timeZone: json['timezone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (id != null) {
      data['id'] = id;
    }
    if (profilePicture != null) {
      data['profile_picture'] = profilePicture;
    }
    if (name != null) {
      data['name'] = name;
    }
    if (middleName != null) {
      data['middle_name'] = middleName;
    }
    if (lastName != null) {
      data['last_name'] = lastName;
    }
    if (birthDate != null) {
      data['birth_date'] = birthDate?.toIso8601String();
    }
    if (gender != null) {
      data['gender'] = gender;
    }
    if (language != null) {
      data['language'] = language;
    }
    if (timeZone != null) {
      data['timezone'] = timeZone;
    }

    return data;
  }
}
