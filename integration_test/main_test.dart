import 'package:integration_test/integration_test.dart';

import 'demo_test.dart' as demo;

void main() {
  // for `flutter drive`
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  demo.test();
}
