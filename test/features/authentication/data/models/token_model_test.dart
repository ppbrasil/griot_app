// import 'package:dartz/dartz.dart';
import 'dart:convert';

import 'package:griot_app/authentication/data/models/token_model.dart';
import 'package:griot_app/authentication/domain/entities/token.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tTokenModel = TokenModel(tokenString: 'yjtcuyrskuhbkjhftrwsujytfciukyhgiutfvk');

  test(
    'Should be a subclass of Token entity',
    () async {
      //assert
      expect(tTokenModel, isA<Token>());
    },
  );

  group('fromJson', () { 
    test(
      'Should return valid token model when credentials are provided',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = 
          json.decode(fixture('auth_success_response.json'));

        // act
        final result = TokenModel.fromJson(jsonMap);
        
        // assert
        expect(result, tTokenModel);
      }
    );
    test(
    'Should return valid token model token key is provided',
    () async {
      // arrange
      final Map<String, dynamic> jsonMap = 
        json.decode(fixture('auth_success_response.json'));

      // act
      final result = TokenModel.fromJson(jsonMap);
        
      // assert
      expect(result, equals(tTokenModel));
    },
  );

    test(
    'Should throw an exception if token key is not provided',
    () async {
      // arrange
      final Map<String, dynamic> jsonMap = 
        json.decode(fixture('auth_invalid_response.json'));

      // act
      const call = TokenModel.fromJson;

      // assert
      expect(() => call(jsonMap), throwsException);
    },
  );

  });
}