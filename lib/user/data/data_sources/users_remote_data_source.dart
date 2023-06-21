import 'package:griot_app/accounts/domain/entities/account.dart';

abstract class UsersRemoteDataSource {
  Future<List<Account>> getBelovedAccountsListFromAPI();
  Future<List<Account>> getOwnedAccountsListFromAPI();
}
