import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:griot_app/core/data/token_provider.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:griot_app/accounts/data/models/account_model.dart';
import 'package:griot_app/accounts/data/models/beloved_one_model.dart';

abstract class AccountsRemoteDataSource {
  Future<AccountModel> getAccountDetailsFromAPI({required int accountId});
/*  Future<BelovedOneModel> getBelovedOneDetailsFromAPI(
      {required int belovedOneid});
      */
  Future<List<BelovedOneModel>> getBelovedOnesListFromAPI(
      {required int accountId});
}

class AccountsRemoteDataSourceImpl implements AccountsRemoteDataSource {
  final http.Client client;
  final TokenProvider tokenProvider;

  AccountsRemoteDataSourceImpl(
      {required this.client, required this.tokenProvider});

  @override
  Future<AccountModel> getAccountDetailsFromAPI(
      {required int accountId}) async {
    final String token = await tokenProvider.getToken();

    final response = await client.get(
      Uri.parse(
          'http://app.griot.me/api/account/retrieve/$accountId/'), // You need to modify the API endpoint as per your application's requirement.
      headers: {'Content-Type': 'application/json', 'Authorization': token},
    );

    if (response.statusCode == 200) {
      return AccountModel.fromJson(json.decode(response.body));
    } else {
      throw InvalidTokenException();
    }
  }

/*  @override
  Future<BelovedOneModel> getBelovedOneDetailsFromAPI(
      {required int belovedOneid}) {
    // TODO: implement getBelovedOneDetailsFromAPI
    throw UnimplementedError();
  }
*/
  @override
  Future<List<BelovedOneModel>> getBelovedOnesListFromAPI(
      {required int accountId}) async {
    final String token = await tokenProvider.getToken();

    final response = await client.get(
      Uri.parse(
          'http://app.griot.me/api/account/retrieve/$accountId/'), // You need to modify the API endpoint as per your application's requirement.
      headers: {'Content-Type': 'application/json', 'Authorization': token},
    );

    if (response.statusCode == 200) {
      final List belovedOnesJson =
          json.decode(response.body)['beloved_ones_profiles'];
      return belovedOnesJson
          .map((belovedOne) => BelovedOneModel.fromJson(belovedOne))
          .toList();

      //return BelovedOneListModel.fromJson(
      //    json.decode(response.body)['beloved_ones_profiles']);
    } else {
      throw InvalidTokenException();
    }
  }
}
