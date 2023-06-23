import 'dart:convert';

import 'package:griot_app/core/data/token_provider.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:griot_app/core/services/thumbnail_services.dart';
import 'package:griot_app/memories/data/models/memory_model.dart';
import 'package:griot_app/memories/data/models/video_model.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/domain/entities/video.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

abstract class MemoriesRemoteDataSource {
  Future<List<MemoryModel>> getMemoriesListFromAPI();
  Future<MemoryModel> getMemoryDetailsFromAPI({required int memoryId});
  Future<MemoryModel> postMemoryToAPI({required Memory memory});
  Future<VideoModel> postVideoToAPI(
      {required Video video, required int memoryId});
}

class MemoriesRemoteDataSourceImpl implements MemoriesRemoteDataSource {
  final http.Client client;
  final TokenProvider tokenProvider;
  final ThumbnailService thumbnailService;

  MemoriesRemoteDataSourceImpl({
    required this.client,
    required this.tokenProvider,
    required this.thumbnailService,
  });

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
  Future<MemoryModel> postMemoryToAPI({
    required Memory memory,
  }) async {
    final String token = await tokenProvider.getToken();

    final response = await client.post(
      Uri.parse('http://app.griot.me/api/memory/create/'),
      headers: {'Content-Type': 'application/json', 'Authorization': token},
      body: jsonEncode({
        'account': memory.accountId,
        'title': 'new',
      }),
    );

    if (response.statusCode == 201) {
      return MemoryModel.fromJson(json.decode(response.body));
    } else {
      throw InvalidTokenException();
    }
  }

  @override
  Future<VideoModel> postVideoToAPI({
    required Video video,
    required int memoryId,
  }) async {
    final String token = await tokenProvider.getToken();

    // Generate the thumbnail
    final thumbnailBytes =
        await thumbnailService.generateThumbnail(videoUrl: video.file);

    if (thumbnailBytes == null) {
      throw Exception('Failed to generate thumbnail.');
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://app.griot.me/api/memory/video/upload/'),
    );

    request.headers.addAll({
      'Authorization': token,
    });

    request.fields['memory'] = memoryId.toString();

    // Add the video file
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        video.file,
        contentType: MediaType('video', 'mp4'),
      ),
    );

    // Add the thumbnail
    request.files.add(
      http.MultipartFile.fromBytes(
        'thumbnail',
        thumbnailBytes,
        filename: '${video.file.split('/').last}_thumbnail.png',
        contentType: MediaType('image', 'png'),
      ),
    );

    var response = await request.send();

    if (response.statusCode == 201) {
      // http.Response.fromStream() returns a Future that completes after the response body is read.
      final responseBody = await http.Response.fromStream(response);
      return VideoModel.fromJson(json.decode(responseBody.body));
    } else {
      throw Exception(
          'Failed to upload video. Server responded with status code ${response.statusCode}.');
    }
  }
}
