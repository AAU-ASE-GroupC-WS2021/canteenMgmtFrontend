// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:canteen_mgmt_frontend/main.dart';
import 'package:canteen_mgmt_frontend/models/dish.dart';
import 'package:canteen_mgmt_frontend/services/dish_service.dart';
import 'package:canteen_mgmt_frontend/services/key_value_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import 'demo_test.mocks.dart'; // if this fails run build_runner (see readme)

// generate a mocked version of DishService
// to actually generate the .mocks.dart file, run `flutter pub run build_runner build --delete-conflicting-outputs`
@GenerateMocks([DishService])
void main() {
  GetIt.I.registerSingleton(KeyValueStore());
  GetIt.I.registerLazySingleton<http.Client>(() => http.Client());
  testWidgets('demo test', (WidgetTester tester) async {
    // create and register mocked service
    // see how the service is registered in lib/main.dart and accessed in lib/screens/dish_service_demo.dart
    final dishService = MockDishService();
    // register as singleton to force the app to use our instance (for which we define stubs further along)
    GetIt.I.registerSingleton<DishService>(dishService);

    // set up stub for fetchDishes()
    // since the service works asynchronously (because of networking),
    // using ".thenAnswer" and wrapping the result in a Future is necessary
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

    // set up stub for createDish (this is required, even if we are not interested in the value)
    // as a return value we just use the input
    when(dishService.createDish(any))
        .thenAnswer((call) => Future.value(call.positionalArguments[0]));

    // start the app in the test environment
    await tester.pumpWidget(MyApp());

    // check if some text we expect to see at this point is actually here
    // note that find.text matches the complete text exactly, so find.text('Canteen') finds nothing
    // see the other methods of "find" for different approaches
    expect(find.text('Canteen Management'), findsOneWidget);

    // push a button
    // we need to await the tap itself and then wait for any ongoing animations to finish
    await tester.tap(find.text('Dish Service Demo'));
    await tester.pumpAndSettle();

    expect(find.text('Refresh'), findsWidgets);
    // check if the expected (mocked) dishes are actually shown
    expect(find.text('Test Dish 1'), findsOneWidget);
    expect(find.text('Test Dish 2'), findsOneWidget);

    // the createDish method should not have been called up to now, so we check that
    verifyNever(dishService.createDish(any));

    await tester.tap(find.text('Create Dish'));
    await tester.pumpAndSettle();

    // but after pressing the button, we do expect that the method was called
    verify(dishService.createDish(any));

    expect(find.text('This text appears nowhere in the app!'), findsNothing);
  });
}
