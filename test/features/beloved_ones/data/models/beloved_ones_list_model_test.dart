import 'dart:convert';

import 'package:griot_app/beloved_ones/data/models/beloved_one_model.dart';
import 'package:griot_app/beloved_ones/data/models/beloved_ones_list_model.dart';
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tBelovedOneModel1 = BelovedOneModel(
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
  const tBelovedOneModel2 = BelovedOneModel(
    id: 4,
    profilePicture: null,
    name: "Bianca",
    middleName: null,
    lastName: "Caffaro",
    birthDate: null,
    gender: "female",
    language: "pt",
    timeZone: "America/Sao_Paulo",
  );
  const tBelovedOneModel3 = BelovedOneModel(
    id: 2,
    profilePicture:
        "https://griot-memories-data.s3.amazonaws.com/profile_pictures/WhatsApp_Image_2023-06-03_at_10.05.53_AM.jpeg",
    name: "Ana Clara",
    middleName: null,
    lastName: "Estephan",
    birthDate: null,
    gender: "female",
    language: "pt",
    timeZone: "America/Sao_Paulo",
  );

  group('fromJson', () {
    test('Should return a valid BelovedOneListModel from a valid JSON list',
        () async {
      // arrange
      final List<dynamic> jsonList = json.decode(
          fixture('beloved_ones_list_success.json'))['beloved_ones_profiles'];
      // act
      final result = BelovedOneListModel.fromJson(jsonList);
      // assert
      expect(result.belovedOnes[0], tBelovedOneModel1);
      expect(result.belovedOnes[1], tBelovedOneModel2);
      expect(result.belovedOnes[2], tBelovedOneModel3);
    });
  });
}
