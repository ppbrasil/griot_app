import 'dart:convert';

import 'package:griot_app/authentication/data/models/token_model.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:http/http.dart' as http;


abstract class AuthRemoteDataSource {  
  Future<TokenModel> login(String username, String password);
  Future<void> storeToken(TokenModel tokenToStore);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});


  @override
  Future<TokenModel> login(String username, String password) async {
    final Map<String, dynamic> body = {
    'username': username,
    'password': password,
    };

    final response = await client.post(
      Uri.parse('http://app.griot.me/api/user/auth/'), 
      headers:{'Content-Type': 'application/json',},
      body: body,
    );
    if (response.statusCode == 200) {
      return TokenModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> storeToken(TokenModel tokenToStore) {
    throw UnimplementedError();
  }

}