import 'dart:convert';

import 'package:griot_app/authentication/data/models/token_model.dart';
import 'package:griot_app/authentication/domain/entities/token.dart';
import 'package:griot_app/core/data/griot_http_client_wrapper.dart';
import 'package:griot_app/core/data/token_provider.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthRemoteDataSource {
  Future<TokenModel> login(String username, String password);
  Future<void> storeTokenToSharedPreferences(TokenModel tokenToStore);
  Future<bool> destroyTokenFromSharedPreferences();
  Future<Token> retrieveTokenFromSharedPreferences();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final GriotHttpServiceWrapper client;
  final TokenProvider tokenProvider;
  final SharedPreferences sharedPreferences;

  AuthRemoteDataSourceImpl(
      {required this.client,
      required this.sharedPreferences,
      required this.tokenProvider});

  @override
  Future<TokenModel> login(String username, String password) async {
    final Map<String, dynamic> body = {
      "username": username,
      "password": password,
    };

    //String finalbody = jsonEncode(body);

    final response =
        await client.post(Uri.parse('http://app.griot.me/api/user/auth/'),
            headers: {
              'Content-Type': 'application/json',
            },
            //body: body,
            body: jsonEncode(body));

    return response.fold(
      (exception) {
        throw exception;
      },
      (response) {
        if (response.statusCode == 200) {
          return TokenModel.fromJson(json.decode(response.body));
        }
        throw ServerException();
      },
    );
  }

  @override
  Future<void> storeTokenToSharedPreferences(TokenModel tokenToStore) async {
    sharedPreferences.setString('token', tokenToStore.tokenString);
  }

  @override
  Future<bool> destroyTokenFromSharedPreferences() {
    final destroyed = sharedPreferences.remove('token');
    return destroyed;
  }

  @override
  Future<Token> retrieveTokenFromSharedPreferences() async {
    final tokenString = await tokenProvider.getToken();
    final token = Token(tokenString: tokenString);
    return token;
  }
}
