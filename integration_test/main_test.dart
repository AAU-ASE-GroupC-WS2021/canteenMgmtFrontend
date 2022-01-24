import 'package:integration_test/integration_test.dart';

import 'about_button_test.dart' as about_button;
import 'demo_test.dart' as demo;

void main() {
  // for `flutter drive`
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  demo.test();
  about_button.test();
}
