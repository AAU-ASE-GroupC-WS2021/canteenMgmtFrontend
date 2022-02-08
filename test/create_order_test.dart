/*
@GenerateMocks([OrderService, DishService])
void main() {
  Widget testWidget = const MaterialApp(
    home: Scaffold(
      body: CreateOrderScreen(canteenId: 1),
    ),
  );

  const _dishes = [
    Dish(id: 1, name: "Dish1", price: 1.3, type: "STARTER"),
    Dish(id: 2, name: "Dish2", price: 4.3, type: "MAIN"),
    Dish(id: 3, name: "Dish3", price: 5.3, type: "DESSERT"),
  ];

  final Order resultOrder = Order(id: 1, pickupDate: DateTime.now(), canteenId: 1,reserveTable: false, dishes: <Dish, int>{}, userId: 1);
  final orderService = MockOrderService();
  GetIt.I.registerSingleton<OrderService>(OrderService());
  final dishService = MockDishService();
  GetIt.I.registerSingleton<DishService>(DishService());
  GetIt.I.registerLazySingleton<OrderCubit>(() => OrderCubit());
  GetIt.I.registerLazySingleton<DishCubit>(() => DishCubit());

  setUp(() {
    when(dishService.fetchDishes()).thenAnswer((_) async => _dishes);
    when(orderService.createOrder(any)).thenAnswer((_) async => resultOrder);
  });

  testWidgets(
    'test all button/ error message states',
        (WidgetTester tester) async {
      useUHDResolution(tester);
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add).at(0));
      await tester.tap(find.byIcon(Icons.add).at(1));
      await tester.tap(find.byIcon(Icons.add).at(2));
      double calcTotal = _dishes[0].price + _dishes[1].price +_dishes[1].price;
      expect(find.textContaining('Total: ' + calcTotal.toString()) , findsWidgets);
    },
  );
}
*/
