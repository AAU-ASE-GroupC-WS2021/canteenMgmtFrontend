import 'package:canteen_mgmt_frontend/main.dart' as app;
import 'package:integration_test/integration_test.dart';
import 'about_button_test.dart' as about_button;
import 'demo_test.dart' as demo;
import 'admin_dashboard_test.dart' as admin_dashboard;
import 'util/test_utils.dart';

Future<void> main() async {
  // for `flutter drive`
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  //demo.test();
  about_button.test();
  admin_dashboard.test();
}
