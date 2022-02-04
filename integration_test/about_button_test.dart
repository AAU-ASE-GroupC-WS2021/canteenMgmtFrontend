import 'package:canteen_mgmt_frontend/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

const aboutItems = [
  String.fromEnvironment('GIT_URL'),
  String.fromEnvironment('GIT_BRANCH'),
  String.fromEnvironment('COMMIT_HASH'),
  String.fromEnvironment('CI_PROVIDER'),
  String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: 'http://localhost:8080/',
  ),
];

// allow running this test by itself
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  test();
}

Future<void> test() async {
  testWidgets("AboutButton test", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.info), findsOneWidget);
    await tester.tap(find.widgetWithIcon(IconButton, Icons.info));
    await tester.pumpAndSettle(); // wait until popup has opened

    for (final item in aboutItems) {
      expect(find.textContaining(item), findsWidgets);
    }
  });
}
