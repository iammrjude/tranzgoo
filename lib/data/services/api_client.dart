import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tranzgoo/data/services/api_config.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/data/services/session_storage.dart';

class ApiClient {
  final http.Client _httpClient;
  final SessionStorage _sessionStorage;

  ApiClient({
    http.Client? httpClient,
    SessionStorage? sessionStorage,
  })  : _httpClient = httpClient ?? http.Client(),
        _sessionStorage = sessionStorage ?? SessionStorage();

  Future<Map<String, dynamic>> get(
    String path, {
    bool authenticated = false,
  }) async {
    final response = await _send(
      () async {
        return _httpClient
            .get(
              ApiConfig.uri(path),
              headers: await _headers(authenticated: authenticated),
            )
            .timeout(ApiConfig.timeout);
      },
    );

    return _decode(response);
  }

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body, {
    bool authenticated = false,
  }) async {
    final response = await _send(
      () async {
        return _httpClient
            .post(
              ApiConfig.uri(path),
              headers: await _headers(authenticated: authenticated),
              body: jsonEncode(body),
            )
            .timeout(ApiConfig.timeout);
      },
    );

    return _decode(response);
  }

  Future<Map<String, String>> _headers({required bool authenticated}) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (authenticated) {
      final token = await _sessionStorage.getToken();

      if (token == null || token.isEmpty) {
        throw const ApiException('Please log in again.');
      }

      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<http.Response> _send(Future<http.Response> Function() request) async {
    try {
      return await request();
    } on TimeoutException {
      throw const ApiException('The server took too long to respond.');
    } on http.ClientException {
      throw const ApiException('Unable to connect to the server.');
    } on FormatException {
      throw const ApiException('The server returned an invalid response.');
    }
  }

  Map<String, dynamic> _decode(http.Response response) {
    final payload = response.body.trim().isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body);

    if (payload is! Map<String, dynamic>) {
      throw const ApiException('The server returned an invalid response.');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        payload['message']?.toString() ?? 'Request failed.',
        statusCode: response.statusCode,
      );
    }

    if (payload['success'] == false) {
      throw ApiException(
        payload['message']?.toString() ?? 'Request failed.',
        statusCode: response.statusCode,
      );
    }

    return payload;
  }
}
