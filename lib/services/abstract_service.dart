import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'auth_token.dart';

abstract class AbstractService {
  static const backendUrl = String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: 'http://localhost:8080/',
  );

  final http.Client _client;

  AbstractService() : _client = GetIt.I.get<http.Client>();

  Uri _getUri(
    String path, [
    Map<String, String>? queryParams,
  ]) {
    final uri = Uri.parse(backendUrl + path);
    return queryParams == null
        ? uri
        : uri.replace(queryParameters: queryParams);
  }

  Future<http.Response> get(
    String path, {
    Map<String, String>? queryParams,
  }) {
    return _client.get(_getUri(path, queryParams), headers: headers);
  }

  Future<http.Response> post(
    String path,
    String body, {
    Map<String, String>? queryParams,
  }) {
    return _client.post(
      _getUri(path, queryParams),
      body: body,
      headers: headers,
    );
  }

  Future<http.Response> delete(
    String path,
    String body, {
    Map<String, String>? queryParams,
  }) {
    return _client.delete(
      _getUri(path, queryParams),
      body: body,
      headers: headers,
    );
  }

  Future<http.Response> put(
    String path,
    String body, {
    Map<String, String>? queryParams,
  }) {
    return _client.put(
      _getUri(path, queryParams),
      body: body,
      headers: headers,
    );
  }

  /// Set X-XSRF-TOKEN header if cookie is set
  Map<String, String> get headers {
    final String? token = AuthTokenUtils.getAuthToken();

    return {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      if (token != null) AuthTokenUtils.authTokenKey: token,
    };
  }
}
