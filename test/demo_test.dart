// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:canteen_mgmt_frontend/main.dart';
import 'package:canteen_mgmt_frontend/models/dish.dart';
import 'package:canteen_mgmt_frontend/services/dish_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'demo_test.mocks.dart';

@GenerateMocks([DishService])
void main() {
  testWidgets('demo test', (WidgetTester tester) async {
    final dishService = MockDishService();
    GetIt.I.registerSingleton<DishService>(dishService);

    when(dishService.fetchDishes()).thenAnswer((_) => Future.value(const [
      Dish(
        name: "Test Dish 1",
        price: 9.99,
        type: "STARTER",
      ),
      Dish(
        name: "Test Dish 2",
        price: 10,
        type: "MAIN",
      ),
    ]));

    when(dishService.createDish(any))
        .thenAnswer((call) => Future.value(call.positionalArguments[0]));

    await tester.pumpWidget(MyApp());

    expect(find.text('Canteen Management'), findsOneWidget);

    await tester.tap(find.text('Dish Service Demo'));
    await tester.pumpAndSettle();

    expect(find.text('Refresh'), findsWidgets);
    expect(find.text('Test Dish 1'), findsOneWidget);
    expect(find.text('Test Dish 2'), findsOneWidget);

    verifyNever(dishService.createDish(any));

    await tester.tap(find.text('Create Dish'));
    await tester.pumpAndSettle();

    verify(dishService.createDish(any));

    expect(find.text('This text appears nowhere in the app!'), findsNothing);
  });
}
