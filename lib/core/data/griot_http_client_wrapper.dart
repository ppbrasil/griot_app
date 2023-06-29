import 'dart:convert';
import 'package:http/http.dart' as http;

class GriotHttpServiceWrapper {
  final http.Client client;

  GriotHttpServiceWrapper({required this.client});

  Future<http.Response> get({
    required Uri url,
    required Map<String, String> headers,
  }) async {
    final response = await client.get(
      url,
      headers: headers,
    );
    return response;
  }

  Future<http.Response> post(
    Uri url, {
    required Map<String, String> headers,
    required Object? body,
  }) async {
    final response = await client.post(
      url,
      headers: headers,
      body: body,
    );
    return response;
  }

  Future<http.Response> put({
    required Uri url,
    required Map<String, String> headers,
    required Object? body,
  }) async {
    final response = await client.put(
      url,
      headers: headers,
      body: body,
    );
    return response;
  }

  Future<http.Response> delete({
    required Uri url,
    required Map<String, String> headers,
  }) async {
    final response = await client.delete(
      url,
      headers: headers,
    );
    return response;
  }

  Future<http.Response> patch({
    required Uri url,
    required Map<String, String> headers,
    required Object? body,
  }) async {
    final response = await client.patch(
      url,
      headers: headers,
      body: body,
    );
    return response;
  }
}
