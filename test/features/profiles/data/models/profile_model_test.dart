import 'dart:convert';

import 'package:griot_app/profile/data/models/profile_model.dart';
import 'package:griot_app/profile/domain/entities/profile.dart';
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const int tYear = 1980;
  const int tDay = 16;
  const int tMonth = 12;

  ProfileModel tProfileModel = ProfileModel(
    id: 1,
    profilePicture:
        "https://griot-memories-data.s3.amazonaws.com/profile_pictures/3x4.jpg",
    name: "Pedro Paulo",
    middleName: "Brasil",
    lastName: "de Assis Ribeiro",
    birthDate: DateTime(tYear, tMonth, tDay),
    gender: "male",
    language: "pt",
    timeZone: "America/Sao_Paulo",
  );

  test(
    'Should be a subclass of Profile entity',
    () async {
      expect(tProfileModel, isA<Profile>());
    },
  );

  group('fromJson', () {
    test('Should return a valid profile model from a valid JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('profile_details_success.json'));
      // act
      final result = ProfileModel.fromJson(jsonMap);
      // assert
      expect(result, tProfileModel);
    });
    test('Should handle null profile picture from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('profile_details_no_picture.json'));
      // act
      final result = ProfileModel.fromJson(jsonMap);
      // assert
      expect(result.profilePicture, null);
      // you can add additional asserts to check other fields if you want
    });

    test('Should handle null middle name from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('profile_details_no_middle_name.json'));
      // act
      final result = ProfileModel.fromJson(jsonMap);
      // assert
      expect(result.middleName, null);
      // you can add additional asserts to check other fields if you want
    });
  });

  group('toJson', () {
    test('Should return a JSON map containing the proper data for a profile',
        () async {
      // act
      final result = tProfileModel.toJson();
      // assert
      final expectedMap = {
        "id": 1,
        "profile_picture":
            "https://griot-memories-data.s3.amazonaws.com/profile_pictures/3x4.jpg",
        "name": "Pedro Paulo",
        "middle_name": "Brasil",
        "last_name": "de Assis Ribeiro",
        "birth_date": "1980-12-16",
        "gender": "male",
        "language": "pt",
        "timezone": "America/Sao_Paulo",
      };
      expect(result, expectedMap);
    });
  });
}
