import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:griot_app/accounts/data/models/account_model.dart';
import 'package:griot_app/user/data/models/user_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const AccountModel ownedAccount = AccountModel(name: 'my Account', id: 1);
  const UserModel tUserModel = UserModel(
    belovedAccounts: [],
    ownedAccounts: [ownedAccount],
  );

  group('fromJson', () {
    test('Should return a valid UserModel from a valid JSON list', () async {
      // arrange
      final Map<String, dynamic> jsonObject =
          json.decode(fixture('user_accounts_sucess.json'));
      // act
      final result = UserModel.fromJson(jsonObject);
      // assert
      expect(result, tUserModel);
    });
  });
}
