import 'dart:convert';

import 'package:griot_app/core/data/griot_http_client_wrapper.dart';
import 'package:griot_app/core/data/token_provider.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:griot_app/profile/data/models/profile_model.dart';
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

class ProfilesRemoteDataSourceImpl implements ProfilesRemoteDataSource {
  final GriotHttpServiceWrapper client;
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

    return response.fold(
      (exception) {
        throw InvalidTokenException();
      },
      (response) {
        if (response.statusCode == 200) {
          return ProfileModel.fromJson(json.decode(response.body));
        }
        throw ServerException();
      },
    );
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
        if (profilePicture != null) 'profile_picture': profilePicture,
        if (name != null) 'name': name,
        if (middleName != null) 'middle_name': middleName,
        if (lastName != null) 'last_name': lastName,
        if (birthDate != null) 'birth_date': formatter.format(birthDate),
        if (gender != null) 'gender': gender,
        if (language != null) 'language': language,
        if (timeZone != null) 'timezone': timeZone,
      }),
    );

    return response.fold(
      (exception) {
        throw ServerException();
      },
      (response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          return ProfileModel.fromJson(json.decode(response.body));
        }
        throw ServerException();
      },
    );
  }
}
