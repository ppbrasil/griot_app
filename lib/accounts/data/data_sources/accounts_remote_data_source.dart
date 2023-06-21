import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:griot_app/core/data/token_provider.dart';

import 'package:griot_app/accounts/domain/entities/account.dart';
import 'package:griot_app/accounts/domain/entities/beloved_one.dart';
import 'package:griot_app/core/error/exceptions.dart';

abstract class AccountsRemoteDataSource {
  Future<Account> getAccountDetailsFromAPI();
  Future<BelovedOne> getBelovedOneDetailsFromAPI();
  Future<List<BelovedOne>> getBelovedOnesListFromAPI();
}

class AccountsRemoteDataSourceImpl implements AccountsRemoteDataSource {
  final http.Client client;
  final TokenProvider tokenProvider;

  AccountsRemoteDataSourceImpl(
      {required this.client, required this.tokenProvider});

  @override
  Future<Account> getAccountDetailsFromAPI() {
    // TODO: implement getAccountDetailsFromAPI
    throw UnimplementedError();
  }

  @override
  Future<BelovedOne> getBelovedOneDetailsFromAPI() {
    // TODO: implement getBelovedOneDetailsFromAPI
    throw UnimplementedError();
  }

  @override
  Future<List<BelovedOne>> getBelovedOnesListFromAPI() {
    // TODO: implement getBelovedOnesListFromAPI
    throw UnimplementedError();
  }
}
