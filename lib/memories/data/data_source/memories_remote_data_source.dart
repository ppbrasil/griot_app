import 'dart:convert';

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

  MemoriesRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MemoryModel>> getMemoriesListFromAPI() async {
    final response = await client.get(
      Uri.parse('http://app.griot.me/api/memories/'),
      headers: {'Content-Type': 'application/json'},
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
    final response = await client.get(
      Uri.parse('http://app.griot.me/api/memories/$memoryId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return MemoryModel.fromJson(json.decode(response.body));
    } else {
      throw InvalidTokenException();
    }
  }

  @override
  Future<MemoryModel> postMemoryToAPI({required String title}) async {
    final response = await client.post(
      Uri.parse('http://app.griot.me/api/memories/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title}),
    );

    if (response.statusCode == 201) {
      return MemoryModel.fromJson(json.decode(response.body));
    } else {
      throw InvalidTokenException();
    }
  }
}
