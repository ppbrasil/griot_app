import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

// Define any custom types here. For example, if ServerException is a custom type, you might need to define it.

class ServerException implements Exception {}

class Token {
  // Assume this is your model class. You might need to define fromJson() method based on your JSON structure.
  Token.fromJson(Map<String, dynamic> json);
}

class APIClient {
  final http.Client client;
  static const baseUrl = 'https://www.griot.me/api';

  APIClient({required this.client});

  Future<Token> login(String email, String password) async {
    final response =
        await post('user/auth/', data: {'email': email, 'password': password});
    if (response.statusCode != 200) {
      throw ServerException();
    }

    final token = Token.fromJson(json.decode(response.body));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token.toString());

    return token;
  }

  Future<http.Response> post(String path,
      {required Map<String, String> data, String? token}) async {
    final url = Uri.parse('$baseUrl/$path');

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final body = json.encode(data);

    return client.post(url, headers: headers, body: body);
  }
}
