import 'dart:convert';

import 'package:griot_app/beloved_ones/data/models/beloved_one_model.dart';
import 'package:griot_app/beloved_ones/domain/entities/beloved_one.dart';
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tBelovedOneModel = BelovedOneModel(
    id: 1,
    profilePicture:
        "https://griot-memories-data.s3.amazonaws.com/profile_pictures/my_profile.jpeg",
    name: "Pedro",
    middleName: null,
    lastName: "Brasil",
    birthDate: null,
    gender: "male",
    language: "pt",
    timeZone: "America/Sao_Paulo",
  );

  test(
    'Should be a subclass of Memory entity',
    () async {
      expect(tBelovedOneModel, isA<BelovedOne>());
    },
  );

  group('fromJson', () {
    test('Should return a valid BelovedOneModel from a valid JSON object',
        () async {
      // arrange
      final List<dynamic> jsonList = json.decode(
          fixture('beloved_ones_list_success.json'))['beloved_ones_profiles'];
      final Map<String, dynamic> jsonObject =
          jsonList[0]; // Assuming the first profile corresponds to Pedro
      // act
      final result = BelovedOneModel.fromJson(jsonObject);
      // assert
      expect(result, tBelovedOneModel);
    });
  });
}
