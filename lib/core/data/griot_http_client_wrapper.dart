import 'package:dartz/dartz.dart';
import 'package:griot_app/core/domain/repositories/core_repository.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:http/http.dart' as http;

class GriotHttpServiceWrapper {
  final CoreRepository coreRepository;
  final http.Client client;

  GriotHttpServiceWrapper({required this.client, required this.coreRepository});

  Future<Either<Exception, http.Response>> get(
    Uri url, {
    required Map<String, String> headers,
  }) async {
    final response = await client.get(
      url,
      headers: headers,
    );
    final finalResponse = await handleError(response);
    return finalResponse;
  }

  Future<Either<Exception, http.Response>> post(
    Uri url, {
    required Map<String, String> headers,
    required Object? body,
  }) async {
    final response = await client.post(
      url,
      headers: headers,
      body: body,
    );
    final finalResponse = await handleError(response);
    return finalResponse;
  }

  Future<Either<Exception, http.Response>> put(
    Uri url, {
    required Map<String, String> headers,
    required Object? body,
  }) async {
    final response = await client.put(
      url,
      headers: headers,
      body: body,
    );
    final finalResponse = await handleError(response);
    return finalResponse;
  }

  Future<Either<Exception, http.Response>> delete(
    Uri url, {
    required Map<String, String> headers,
  }) async {
    final response = await client.delete(
      url,
      headers: headers,
    );
    final finalResponse = await handleError(response);
    return finalResponse;
  }

  Future<Either<Exception, http.Response>> patch(
    Uri url, {
    required Map<String, String> headers,
    required Object? body,
  }) async {
    final response = await client.patch(
      url,
      headers: headers,
      body: body,
    );
    final finalResponse = await handleError(response);
    return finalResponse;
  }

  Future<Either<Exception, http.StreamedResponse>> multipartRequest(
    String method,
    Uri url, {
    required Map<String, String> headers,
    required List<http.MultipartFile> files,
    Map<String, String>? fields,
  }) async {
    var request = http.MultipartRequest(method, url)
      ..headers.addAll(headers)
      ..files.addAll(files);

    if (fields != null) {
      request.fields.addAll(fields);
    }

    final response = await client.send(request);
    final finalResponse = await handleMultipartError(response);
    return finalResponse;
  }

  Future<Either<Exception, http.Response>> handleError(response) async {
    if (response.statusCode == 401) {
      await coreRepository.performTokenExceptionPolicies();
      return Left(InvalidTokenException());
    } else if (response.statusCode >= 200 && response.statusCode < 300) {
      return Right(response);
    } else {
      return Left(ServerException());
    }
  }

  Future<Either<Exception, http.StreamedResponse>> handleMultipartError(
      http.StreamedResponse response) async {
    if (response.statusCode == 401) {
      await coreRepository.performTokenExceptionPolicies();
      return Left(InvalidTokenException());
    } else if (response.statusCode >= 200 && response.statusCode < 300) {
      return Right(response);
    } else {
      return Left(ServerException());
    }
  }
}
