import 'package:canteen_mgmt_frontend/main.dart';
import 'package:canteen_mgmt_frontend/services/key_value_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

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

void main() {
  GetIt.I.registerSingleton(KeyValueStore());
  testWidgets('AboutButton test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.byIcon(Icons.info), findsOneWidget);
    await tester.tap(find.widgetWithIcon(IconButton, Icons.info));
    await tester.pumpAndSettle(); // wait until popup has opened

    for (final item in aboutItems) {
      expect(find.textContaining(item), findsWidgets);
    }
  });
}
