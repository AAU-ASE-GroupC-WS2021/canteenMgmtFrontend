import 'package:canteen_mgmt_frontend/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'util/widget_tester_wait_for.dart';

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

    await tester.tap(find.text('Dish Service Demo'));
    await tester.pumpAndSettle();

    expect(find.text('Refresh'), findsOneWidget);
    expect(find.text('Create Dish'), findsOneWidget);
    expect(find.text('Some Test Dish'), findsNothing);

    for (int i = 0; i < 3; i++) {
      await tester.tap(find.text('Create Dish'));
      await tester.pumpAndSettle();
    }

    await tester.tap(find.text('Refresh'));
    await tester.pumpAndSettle();

    await tester.waitFor(find.text('Some Test Dish'));
    expect(find.text('Some Test Dish'), findsNWidgets(3));

    expect(find.text('This text appears nowhere in the app!'), findsNothing);
  });
}
