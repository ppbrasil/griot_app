import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:griot_app/core/data/griot_http_client_wrapper.dart';
import 'package:griot_app/core/domain/repositories/core_repository.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

import 'griot_http_client_wrapper_test.mocks.dart';

@GenerateMocks([http.Client, http.Response, CoreRepository])
void main() {
  final headers = {'Content-Type': 'application/json'};
  const url = 'https://example.com';
  late MockClient client;
  late GriotHttpServiceWrapper wrapper;
  late MockCoreRepository coreRepository;
  late MockResponse response;

  setUp(() {
    response = MockResponse();
    coreRepository = MockCoreRepository();
    client = MockClient();
    wrapper = GriotHttpServiceWrapper(
      client: client,
      coreRepository: coreRepository,
    );
  });

  group('GriotHttpServiceWrapper', () {
    test('get method sends a GET request', () async {
      when(client.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('OK', 200));

      final eitherResponse =
          await wrapper.get(Uri.parse(url), headers: headers);
      final response = eitherResponse.fold(
        (exception) => throw exception, // Rethrow the exception to propagate it
        (response) => response,
      );

      verify(client.get(Uri.parse(url), headers: headers)).called(1);
      expect(response.statusCode, equals(200));
    });

    test('post method sends a POST request and returns response', () async {
      final body = {'key': 'value'};

      when(client.post(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('OK', 201));

      final eitherResponse = await wrapper.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));

      final response = eitherResponse.fold(
        (exception) => throw exception, // Rethrow the exception to propagate it
        (response) => response,
      );

      verify(client.post(Uri.parse(url),
              headers: headers, body: jsonEncode(body)))
          .called(1);
      expect(response.statusCode, equals(201));
    });

    test('put method sends a PUT request and returns response', () async {
      final body = {'key': 'value'};

      when(client.put(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('OK', 200));

      final eitherResponse = await wrapper.put(Uri.parse(url),
          headers: headers, body: jsonEncode(body));
      final response = eitherResponse.fold(
        (exception) => throw exception, // Rethrow the exception to propagate it
        (response) => response,
      );

      verify(client.put(Uri.parse(url),
              headers: headers, body: jsonEncode(body)))
          .called(1);
      expect(response.statusCode, equals(200));
    });

    test('delete method sends a DELETE request and returns response', () async {
      when(client.delete(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('OK', 200));

      final eitherResponse =
          await wrapper.delete(Uri.parse(url), headers: headers);
      final response = eitherResponse.fold(
        (exception) => throw exception, // Rethrow the exception to propagate it
        (response) => response,
      );

      verify(client.delete(Uri.parse(url), headers: headers)).called(1);
      expect(response.statusCode, equals(200));
    });

    test('patch method sends a PATCH request and returns response', () async {
      final body = {'key': 'value'};

      when(client.patch(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('OK', 200));

      final eitherResponse = await wrapper.patch(Uri.parse(url),
          headers: headers, body: jsonEncode(body));
      final response = eitherResponse.fold(
        (exception) => throw exception, // Rethrow the exception to propagate it
        (response) => response,
      );

      verify(client.patch(Uri.parse(url),
              headers: headers, body: jsonEncode(body)))
          .called(1);
      expect(response.statusCode, equals(200));
    });
  });
  group('Error Handling', () {
    test('Calls performTokenExceptionPolicies when status code is 401',
        () async {
      when(response.statusCode).thenReturn(401);
      when(coreRepository.performTokenExceptionPolicies())
          .thenAnswer((_) => Future.value(0));

      final result = await wrapper.handleError(response);

      expect(result.isLeft(), true);
      expect(
          result.fold(
            (left) => left,
            (right) => null,
          ),
          isA<InvalidTokenException>());

      // Verify if performTokenExceptionPolicies method is called
      verify(coreRepository.performTokenExceptionPolicies()).called(1);
    });

    test('Throws ServerException when status code is not 200-299 or 401',
        () async {
      final response = http.Response('', 400);

      final result = await wrapper.handleError(response);

      expect(result.isLeft(), true);
      expect(
          result.fold(
            (left) => left,
            (right) => null,
          ),
          isA<ServerException>());
    });

    test('Does not throw exception when status code is in the range 200-299',
        () async {
      when(response.statusCode).thenReturn(200);

      expect(() async => await wrapper.handleError(response), returnsNormally);
    });
  });
}
