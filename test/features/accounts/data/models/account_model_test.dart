import 'dart:convert';

import 'package:griot_app/accounts/data/models/account_model.dart';
import 'package:griot_app/accounts/domain/entities/account.dart';
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tAccountModel = AccountModel(
    id: 1,
    name: "My Account",
    belovedOnesProfiles: [],
  );

  test(
    'Should be a subclass of Account entity',
    () async {
      expect(tAccountModel, isA<Account>());
    },
  );

  group('fromJson', () {
    test('Should return a valid Account model from a valid JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('account_details_success.json'));
      // act
      final result = AccountModel.fromJson(jsonMap);
      // assert
      expect(result, tAccountModel);
    });
  });
}
