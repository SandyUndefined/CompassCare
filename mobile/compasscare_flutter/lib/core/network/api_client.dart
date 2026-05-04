import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient({
    required String baseUrl,
    http.Client? httpClient,
    String? Function()? authTokenProvider,
  }) : _baseUri = Uri.parse(baseUrl),
       _httpClient = httpClient ?? http.Client(),
       _authTokenProvider = authTokenProvider;

  static const Duration _requestTimeout = Duration(seconds: 8);

  final Uri _baseUri;
  final http.Client _httpClient;
  final String? Function()? _authTokenProvider;

  Uri _resolveUri(String path) {
    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;
    return _baseUri.resolve(normalizedPath);
  }

  Map<String, String> _headers([Map<String, String>? headers]) {
    final token = _authTokenProvider?.call();
    return {
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      ...?headers,
    };
  }

  Future<http.Response> get(String path, {Map<String, String>? headers}) {
    return _withTimeout(
      _httpClient.get(_resolveUri(path), headers: _headers(headers)),
      method: 'GET',
      path: path,
    );
  }

  Future<http.Response> post(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) {
    return _withTimeout(
      _httpClient.post(
        _resolveUri(path),
        headers: _headers({'Content-Type': 'application/json', ...?headers}),
        body: body is String ? body : jsonEncode(body),
      ),
      method: 'POST',
      path: path,
    );
  }

  Future<http.Response> patch(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) {
    return _withTimeout(
      _httpClient.patch(
        _resolveUri(path),
        headers: _headers({'Content-Type': 'application/json', ...?headers}),
        body: body is String ? body : jsonEncode(body),
      ),
      method: 'PATCH',
      path: path,
    );
  }

  Future<http.Response> delete(String path, {Map<String, String>? headers}) {
    return _withTimeout(
      _httpClient.delete(_resolveUri(path), headers: _headers(headers)),
      method: 'DELETE',
      path: path,
    );
  }

  Future<http.Response> _withTimeout(
    Future<http.Response> requestFuture, {
    required String method,
    required String path,
  }) {
    return requestFuture.timeout(
      _requestTimeout,
      onTimeout: () {
        throw TimeoutException(
          '$method $path timed out after ${_requestTimeout.inSeconds}s',
        );
      },
    );
  }

  void close() {
    _httpClient.close();
  }
}
