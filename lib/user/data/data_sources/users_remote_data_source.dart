import 'dart:convert';
import 'package:griot_app/accounts/data/models/account_model.dart';
import 'package:griot_app/core/data/griot_http_client_wrapper.dart';
import 'package:griot_app/core/data/token_provider.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:griot_app/accounts/domain/entities/account.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UsersRemoteDataSource {
  Future<List<Account>> getBelovedAccountsListFromAPI();
  Future<List<Account>> getOwnedAccountsListFromAPI();
  Future<void> storeMainAccountId({required int? mainAccountId});
}

class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  final GriotHttpServiceWrapper client;
  final TokenProvider tokenProvider;

  UsersRemoteDataSourceImpl({
    required this.client,
    required this.tokenProvider,
  });

  @override
  Future<List<Account>> getBelovedAccountsListFromAPI() {
    throw UnimplementedError();
  }

  @override
  Future<List<Account>> getOwnedAccountsListFromAPI() async {
    final String token = await tokenProvider.getToken();

    final response = await client.get(
      Uri.parse('http://app.griot.me/api/user/list-accounts/'),
      headers: {'Content-Type': 'application/json', 'Authorization': token},
    );

    return response.fold(
      (exception) {
        throw exception;
      },
      (response) {
        if (response.statusCode == 200) {
          final List ownedAccountsJson =
              json.decode(response.body)['owned_accounts'];
          return ownedAccountsJson
              .map((ownedAccount) => AccountModel.fromJson(ownedAccount))
              .toList();
        }
        throw ServerException();
      },
    );
  }

  @override
  Future<void> storeMainAccountId({required int? mainAccountId}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('main_account_id', mainAccountId ?? 0);
  }
}
