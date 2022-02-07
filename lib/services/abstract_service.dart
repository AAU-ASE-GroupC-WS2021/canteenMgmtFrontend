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

  Uri _getUri(String path) => Uri.parse(backendUrl + path);

  Future<http.Response> get(path) =>
      _client.get(_getUri(path), headers: getHeaders());

  Future<http.Response> post(path, String body) =>
      _client.post(_getUri(path), body: body, headers: getHeaders());

  Future<http.Response> delete(path, String body) =>
      _client.delete(_getUri(path), body: body, headers: getHeaders());

  Future<http.Response> put(path, String body) =>
      _client.put(_getUri(path), body: body, headers: getHeaders());

  /// Set X-XSRF-TOKEN header if cookie is set
  Map<String, String> getHeaders() {
    final String? token = AuthTokenUtils.getAuthToken();

    return {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      if (token != null) AuthTokenUtils.authTokenKey: token,
    };
  }
}
