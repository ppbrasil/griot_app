import 'dart:convert';
import 'dart:math';

import 'package:griot_app/core/data/griot_http_client_wrapper.dart';
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
  Future<int> deleteVideoFromAPI({required int videoId});
  Future<Memory> patchUpdateMemoryToAPI({required Memory memory});
}

class MemoriesRemoteDataSourceImpl implements MemoriesRemoteDataSource {
  final GriotHttpServiceWrapper client;
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

    return response.fold(
      (exception) {
        throw exception;
      },
      (response) {
        if (response.statusCode == 200) {
          final List memoriesJson = json.decode(response.body);
          return memoriesJson
              .map((memory) => MemoryModel.fromJson(memory))
              .toList();
        }
        throw ServerException();
      },
    );
  }

  @override
  Future<MemoryModel> getMemoryDetailsFromAPI({required int memoryId}) async {
    final String token = await tokenProvider.getToken();

    final response = await client.get(
      Uri.parse('http://app.griot.me/api/memory/retrieve/$memoryId/'),
      headers: {'Content-Type': 'application/json', 'Authorization': token},
    );

    return response.fold(
      (exception) {
        throw InvalidTokenException();
      },
      (response) {
        if (response.statusCode == 200) {
          return MemoryModel.fromJson(json.decode(response.body));
        }
        throw ServerException();
      },
    );
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
        'title': memory.title,
      }),
    );

    return response.fold(
      (exception) {
        throw InvalidTokenException();
      },
      (response) {
        if (response.statusCode == 201) {
          return MemoryModel.fromJson(json.decode(response.body));
        }
        throw ServerException();
      },
    );
  }

  @override
  Future<VideoModel> postVideoToAPI({
    required Video video,
    required int memoryId,
  }) async {
    final String token = await tokenProvider.getToken();

    int randInt = Random().nextInt(1000000);

    // Add the video file
    http.MultipartFile videoFile = await http.MultipartFile.fromPath(
      'file',
      video.file,
      filename: '$memoryId-$randInt.mp4',
      contentType: MediaType('video', 'mp4'),
    );

    // Add the thumbnail
    http.MultipartFile thumbnailFile = http.MultipartFile.fromBytes(
      'thumbnail',
      video.thumbnailData!,
      filename: '$memoryId-$randInt.png',
      contentType: MediaType('image', 'png'),
    );

    // Prepare the fields
    Map<String, String> fields = {'memory': memoryId.toString()};

    // Prepare the headers
    Map<String, String> headers = {'Authorization': token};

    // Send the multipart request
    var response = await client.multipartRequest(
      'POST',
      Uri.parse('http://app.griot.me/api/memory/video/upload/'),
      headers: headers,
      files: [videoFile, thumbnailFile],
      fields: fields,
    );

    return response.fold(
      (exception) {
        // handle exceptions
        throw exception;
      },
      (response) async {
        if (response.statusCode == 201) {
          // http.Response.fromStream() returns a Future that completes after the response body is read.
          final responseBody = await http.Response.fromStream(response);
          return VideoModel.fromJson(json.decode(responseBody.body));
        } else {
          throw ServerException();
        }
      },
    );
  }

  @override
  Future<MemoryModel> patchUpdateMemoryToAPI({required Memory memory}) async {
    final String token = await tokenProvider.getToken();
    final int memoryId = memory.id!;

    final response = await client.patch(
      Uri.parse('http://app.griot.me/api/memory/update/$memoryId/'),
      headers: {'Content-Type': 'application/json', 'Authorization': token},
      body: jsonEncode({
        'account': memory.accountId,
        'title': memory.title,
      }),
    );

    return response.fold(
      (exception) {
        throw InvalidTokenException();
      },
      (response) {
        if (response.statusCode == 201 || response.statusCode == 200) {
          return MemoryModel.fromJson(json.decode(response.body));
        }
        throw ServerException();
      },
    );
  }

  @override
  Future<int> deleteVideoFromAPI({required int videoId}) async {
    final String token = await tokenProvider.getToken();

    final response = await client.delete(
      Uri.parse('http://app.griot.me/api/video/delete/$videoId/'),
      headers: {'Content-Type': 'application/json', 'Authorization': token},
    );

    return response.fold(
      (exception) {
        throw InvalidTokenException();
      },
      (response) {
        if (response.statusCode == 201 || response.statusCode == 204) {
          return 0;
        }
        throw ServerException();
      },
    );
  }
}
