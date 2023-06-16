import 'dart:convert';

import 'package:griot_app/core/data/token_provider.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:griot_app/memories/data/models/memory_model.dart';
import 'package:http/http.dart' as http;

abstract class MemoriesRemoteDataSource {
  Future<List<MemoryModel>> getMemoriesListFromAPI();
  Future<MemoryModel> getMemoryDetailsFromAPI({required int memoryId});
  Future<MemoryModel> postMemoryToAPI({required String title});
}

class MemoriesRemoteDataSourceImpl implements MemoriesRemoteDataSource {
  final http.Client client;
  final TokenProvider tokenProvider;

  MemoriesRemoteDataSourceImpl(
      {required this.tokenProvider, required this.client});

  @override
  Future<List<MemoryModel>> getMemoriesListFromAPI() async {
    final String token = await tokenProvider.getToken();

    final response = await client.get(
      Uri.parse('http://app.griot.me/api/memory/list/'),
      headers: {'Content-Type': 'application/json', 'Authorization': token},
    );

    if (response.statusCode == 200) {
      final List memoriesJson = json.decode(response.body);
      return memoriesJson
          .map((memory) => MemoryModel.fromJson(memory))
          .toList();
    } else {
      throw InvalidTokenException();
    }
  }

  @override
  Future<MemoryModel> getMemoryDetailsFromAPI({required int memoryId}) async {
    final String token = await tokenProvider.getToken();

    final response = await client.get(
      Uri.parse('http://app.griot.me/api/memory/retrieve/$memoryId/'),
      headers: {'Content-Type': 'application/json', 'Authorization': token},
    );

    if (response.statusCode == 200) {
      return MemoryModel.fromJson(json.decode(response.body));
    } else {
      throw InvalidTokenException();
    }
  }

  @override
  Future<MemoryModel> postMemoryToAPI({required String title}) async {
    final String token = await tokenProvider.getToken();

    final response = await client.post(
      Uri.parse('http://app.griot.me/api/memories/'),
      headers: {'Content-Type': 'application/json', 'Authorization': token},
      body: jsonEncode({'title': title}),
    );

    if (response.statusCode == 201) {
      return MemoryModel.fromJson(json.decode(response.body));
    } else {
      throw InvalidTokenException();
    }
  }
}
