import 'dart:convert';

import 'package:griot_app/core/data/token_provider.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:griot_app/profile/data/models/profile_model.dart';
import 'package:griot_app/profile/domain/entities/profile.dart';
import 'package:http/http.dart' as http;

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

class ProfilesRemoteDataSourceImpl implements ProfilesRemoteDataSource {
  final http.Client client;
  final TokenProvider tokenProvider;

  ProfilesRemoteDataSourceImpl(
      {required this.client, required this.tokenProvider});

  @override
  Future<Profile> getProfileDetailsFromAPI() async {
    final String token = await tokenProvider.getToken();

    final response = await client.get(
      Uri.parse(
          'http://app.griot.me/api/profile/retrieve/'), // You need to modify the API endpoint as per your application's requirement.
      headers: {'Content-Type': 'application/json', 'Authorization': token},
    );

    if (response.statusCode == 200) {
      return ProfileModel.fromJson(json.decode(response.body));
    } else {
      throw InvalidTokenException();
    }
  }

  @override
  Future<Profile> updateProfileDetailsOverAPI({
    final String? profilePicture,
    final String? name,
    final String? middleName,
    final String? lastName,
    final DateTime? birthDate,
    final String? gender,
    final String? language,
    final String? timeZone,
  }) async {
    final String token = await tokenProvider.getToken();

    final response = await client.patch(
      Uri.parse(
          'http://app.griot.me/api/profile/update/'), // You need to modify the API endpoint as per your application's requirement.
      headers: {'Content-Type': 'application/json', 'Authorization': token},
      body: jsonEncode({
        'profile_picture': profilePicture,
        'name': name,
        'middle_name': middleName,
        'last_name': lastName,
        'birth_date': formatter.format(birthDate!),
        'gender': gender,
        'language': language,
        'timezone': timeZone,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return ProfileModel.fromJson(json.decode(response.body));
    } else {
      throw InvalidTokenException();
    }
  }
}
