import 'package:http/http.dart' as http;

import 'auth_token.dart';

abstract class AbstractService {
  static const backendUrl = String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: 'http://localhost:8080/',
  );

  final _client = http.Client();

  Uri _getUri(String path) {
    String uriString = backendUrl + path;

    return Uri.parse(uriString);
  }

  Future<http.Response> get(path) {
    var headers = getHeaders();
    return _client.get(_getUri(path), headers: headers);
  }

  Future<http.Response> post(path, String body) {
    var headers = getHeaders();
    return _client.post(_getUri(path), body: body, headers: headers);
  }

  Future<http.Response> delete(path, String body) {
    var headers = getHeaders();
    return _client.delete(_getUri(path), body: body, headers: headers);
  }

  /// Set X-XSRF-TOKEN header if cookie is set
  Map<String, String> getHeaders() {
    String? token = AuthTokenUtils.getAuthToken();

    return {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      if (token != null) AuthTokenUtils.authTokenKey: token,
    };
  }
}
