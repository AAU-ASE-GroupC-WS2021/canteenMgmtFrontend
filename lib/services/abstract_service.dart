import 'package:canteen_mgmt_frontend/utils/auth_token.dart';
import 'package:http/http.dart' as http;

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
    var headers = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
    };

    String? token = AuthTokenUtils.getAuthToken();

    if (token != null) {
      var authHeader = { AuthTokenUtils.authTokenKey: token};
      headers.addAll(authHeader);
    }

    return headers;
  }
}
