import 'package:integration_test/integration_test.dart';

import 'admin_dashboard_test.dart' as admin_dashboard;

Future<void> main() async {
  // for `flutter drive`
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  //await demo.test();
  // await about_button.test();
  await admin_dashboard.test();
}
