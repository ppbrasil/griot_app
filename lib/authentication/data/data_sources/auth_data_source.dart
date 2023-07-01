import 'dart:convert';

import 'package:griot_app/authentication/data/models/token_model.dart';
import 'package:griot_app/core/data/griot_http_client_wrapper.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthRemoteDataSource {
  Future<TokenModel> login(String username, String password);
  Future<void> storeToken(TokenModel tokenToStore);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final GriotHttpServiceWrapper client;

  AuthRemoteDataSourceImpl({required this.client});

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
  Future<void> storeToken(TokenModel tokenToStore) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', tokenToStore.tokenString);
  }
}
