import 'package:canteen_mgmt_frontend/main.dart' as app;
import 'package:canteen_mgmt_frontend/models/canteen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// allow running this test by itself
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  test();
}

final _canteenToCreate =
    Canteen(name: "TestCanteen", address: "TestAddress", numTables: 40);

Future<void> test() async {
  testWidgets("Admin Dashboard test", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Admin Dashboard'));
    await tester.pumpAndSettle();
    expect(find.text('Canteens'), findsWidgets);

    await _createCanteen(tester, _canteenToCreate);
    await _verifyCanteenExists(tester, _canteenToCreate);

    // expect(find.byType(ElevatedButton), findsNWidgets(3));
    //
    // await tester.tap(find.byType(ElevatedButton).at(2));
    // await tester.pumpAndSettle();

    // expect(find.text('Canteens'), findsWidgets);
    // expect(find.text('Staff [all]'), findsWidgets);
    //
    // await _createCanteen(tester, _canteenToCreate);
    // await _verifyCanteenExists(tester, _canteenToCreate);
  });
}

Future<void> _verifyCanteenExists(WidgetTester tester, Canteen canteen) async {
  expect(find.text(canteen.name), findsWidgets);
  expect(find.textContaining(canteen.address), findsWidgets);
}

Future<void> _createCanteen(WidgetTester tester, Canteen canteen) async {
  await tester.tap(find.byIcon(Icons.add).first);
  await tester.pumpAndSettle();
  expect(find.text('Create Canteen'), findsWidgets);

  var textField = find.byType(TextFormField);
  await tester.enterText(textField.at(0), canteen.name);
  await tester.enterText(textField.at(1), canteen.address);
  await tester.enterText(textField.at(2), canteen.numTables.toString());

  await tester.tap(find.byType(ElevatedButton));
  await tester.pumpAndSettle();

  expect(find.text('Create Canteen'), findsNothing);
}
