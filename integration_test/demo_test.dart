import 'package:canteen_mgmt_frontend/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// allow running this test by itself
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  test();
}

Future<void> test() async {
  testWidgets("demo test", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.text('Canteen Management'), findsOneWidget);

    expect(find.text('This text appears nowhere in the app!'), findsNothing);
  });
}
