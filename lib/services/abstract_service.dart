import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'dart:io';

abstract class AbstractService {
  final bool httpsEnabled = false; // private property indicated by leading _
  final String _restURL = 'aau-ase-ws21-canteen-app-dev.herokuapp.com/';
  //final String _restURL = 'localhost:8080/';

  final _client = http.Client();

  String _getProtocol() {
    return httpsEnabled ? 'https' : 'http';
  }

  Uri _getUri(String path) {
    String uriString = _getProtocol() + "://" + _restURL + path;

    return Uri.parse(uriString);
  }

  Cookie? _getCSRFToken() {
    Cookie? cookie;
    if (html.window.document.cookie!.isNotEmpty) {
      cookie = Cookie.fromSetCookieValue(html.window.document.cookie!);
    }

    return cookie;
  }

  Future<http.Response> get(path) {
    return _client.get(_getUri(path), headers: getHeaders());
  }

  Future<http.Response> post(path, String body) {
    return _client.post(_getUri(path), body: body, headers: getHeaders());
  }

  /// Set X-XSRF-TOKEN header if cookie is set
  Map<String, String> getHeaders() {
    var headers = {"Content-Type": "application/json", "Access-Control-Allow-Origin": "*"};
    var csrfToken = _getCSRFToken();
    if (csrfToken != null) {
      headers.addAll({"X-XSRF-TOKEN": csrfToken.value.toString()});
    }

    return headers;
  }
}
