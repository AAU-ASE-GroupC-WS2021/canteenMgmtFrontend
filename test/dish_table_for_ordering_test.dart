/*
@GenerateMocks([DishService])
void main() {
  final completer = Completer<Dish>();
  Widget testWidget = MaterialApp(
    home: Scaffold(
      body: DishTableForOrder(addOrderCallback: (Dish d) {
        completer.complete(d);
      },),
    ),
  );

  const _dishes = [
    Dish(id: 1, name: "Dish1", price: 1.3, type: "STARTER"),
    Dish(id: 2, name: "Dish2", price: 4.3, type: "MAIN"),
    Dish(id: 3, name: "Dish3", price: 5.3, type: "DESSERT"),
  ];
  final dishService = MockDishService();
  GetIt.I.registerSingleton<DishService>(DishService());
  GetIt.I.registerLazySingleton<DishCubit>(() => DishCubit());

  setUp(() {
    when(dishService.fetchDishes()).thenAnswer((_) async => _dishes);
  });

  testWidgets(
    'When launched then all dishes are displayed',
    (WidgetTester tester) async {
      useUHDResolution(tester);
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      for (final dish in _dishes) {
        expect(find.textContaining(dish.name), findsWidgets);
        expect(find.textContaining(dish.price.toString()), findsWidgets);
        expect(find.textContaining(dish.type.toString()), findsWidgets);
      }
    },
  );

  testWidgets(
    'test if the callback gets called properly',
        (WidgetTester tester) async {
      useUHDResolution(tester);
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add).at(0));
      await tester.pumpAndSettle();

      expect(completer.isCompleted, isTrue);
      expect(await completer.future, _dishes[0]);
    },
  );
}
*/
