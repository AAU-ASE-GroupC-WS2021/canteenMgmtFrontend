import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:canteen_mgmt_frontend/main.dart' as app;

void main() {
  // for `flutter drive`
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("demo test", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.text('Canteen Management'), findsOneWidget);

    expect(find.text('This text appears nowhere in the app!'), findsNothing);
  });
}
