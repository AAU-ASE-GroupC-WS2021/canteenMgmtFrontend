import 'package:canteen_mgmt_frontend/main.dart' as app;
import 'package:canteen_mgmt_frontend/main.dart';
import 'package:canteen_mgmt_frontend/models/canteen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';

import 'util/test_utils.dart';
import 'util/widget_tester_wait_for.dart';

// allow running this test by itself
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  test();
}

final _canteenToCreate = Canteen(name: "TestCanteen", address: "TestAddress", numTables: 40);

Future<void> test() async {
  testWidgets("Admin Dashboard test", (WidgetTester tester) async {
    app.main().beamerDelegate.beamToNamed('/admin');
    await tester.pumpAndSettle();

    await _createCanteen(tester, _canteenToCreate);
    await _verifyCanteenExists(tester, _canteenToCreate);

    /*expect(find.byType(ElevatedButton), findsNWidgets(3));

    await tester.tap(find.byType(ElevatedButton).at(2));
    await tester.pumpAndSettle();*/

    /*expect(find.text('Canteens'), findsWidgets);
    expect(find.text('Staff [all]'), findsWidgets);

    await _createCanteen(tester, _canteenToCreate);
    await _verifyCanteenExists(tester, _canteenToCreate);*/
  });
}

Future<void> _verifyCanteenExists(WidgetTester tester, Canteen canteen) async {
  expect(find.text(canteen.name), findsWidgets);
  expect(find.text(canteen.address), findsWidgets);
}

Future<void> _createCanteen(WidgetTester tester, Canteen canteen) async {
  await tester.tap(find.byIcon(Icons.add).at(0));
  await tester.pumpAndSettle();
  expect(find.text('Create Canteen'), findsWidgets);

  await tester.enterText(find.byType(TextFormField).at(0), canteen.name);
  await tester.enterText(find.byType(TextFormField).at(1), canteen.address);
  await tester.enterText(find.byType(TextFormField).at(2), canteen.numTables.toString());

  await tester.tap(find.byType(ElevatedButton));
  await tester.pumpAndSettle();

  expect(find.text('Create Canteen'), findsNothing);
}