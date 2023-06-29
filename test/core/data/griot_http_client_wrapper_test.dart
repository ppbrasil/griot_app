import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:griot_app/core/data/griot_http_client_wrapper.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

import 'griot_http_client_wrapper_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('GriotHttpServiceWrapper', () {
    final headers = {'Content-Type': 'application/json'};
    const url = 'https://example.com';
    late MockClient client;
    late GriotHttpServiceWrapper wrapper;

    setUp(() {
      client = MockClient();
      wrapper = GriotHttpServiceWrapper(client: client);
    });

    test('get method sends a GET request', () async {
      when(client.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('OK', 200));

      final response = await wrapper.get(Uri.parse(url), headers: headers);

      verify(client.get(Uri.parse(url), headers: headers)).called(1);
      expect(response.statusCode, equals(200));
    });

    test('post method sends a POST request and returns response', () async {
      final body = {'key': 'value'};

      when(client.post(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('OK', 201));

      final response = await wrapper.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));

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

      final response = await wrapper.put(Uri.parse(url),
          headers: headers, body: jsonEncode(body));

      verify(client.put(Uri.parse(url),
              headers: headers, body: jsonEncode(body)))
          .called(1);
      expect(response.statusCode, equals(200));
    });

    test('delete method sends a DELETE request and returns response', () async {
      when(client.delete(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('OK', 200));

      final response = await wrapper.delete(Uri.parse(url), headers: headers);

      verify(client.delete(Uri.parse(url), headers: headers)).called(1);
      expect(response.statusCode, equals(200));
    });

    test('patch method sends a PATCH request and returns response', () async {
      final body = {'key': 'value'};

      when(client.patch(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('OK', 200));

      final response = await wrapper.patch(Uri.parse(url),
          headers: headers, body: jsonEncode(body));

      verify(client.patch(Uri.parse(url),
              headers: headers, body: jsonEncode(body)))
          .called(1);
      expect(response.statusCode, equals(200));
    });
  });
}
