abstract class AbstractService {
  final bool httpsEnabled = true;   // private property indicated by leading _
  final String _restURL = 'localhost:8443/';

  String _getProtocol() {
    return httpsEnabled ? 'https' : 'http';
  }

  Uri getUri(String path) {
    String uriString = _getProtocol() + "://" + _restURL + path;
    return Uri.parse(uriString);
  }
}