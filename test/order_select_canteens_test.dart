/*
@GenerateMocks([CanteenService])
void main() {
  Widget testWidget = const MaterialApp(
    home: Scaffold(
      body: OrderSelectCanteenScreen(),
    ),
  );

  const _canteens = [
    Canteen(name: "Canteen1", address: "SomeAddress1", numTables: 11, id: 1),
    Canteen(name: "Canteen2", address: "SomeAddress2", numTables: 22, id: 2),
    Canteen(name: "Canteen3", address: "SomeAddress3", numTables: 33, id: 3),
  ];

  final canteenService = MockCanteenService();
  GetIt.I.registerSingleton<CanteenService>(canteenService);
  GetIt.I.registerLazySingleton<CanteensCubit>(() => CanteensCubit());

  setUp(() {
    when(canteenService.getCanteens()).thenAnswer((_) async => _canteens);
  });

  testWidgets(
    'When launched then all canteens and all users displayed',
        (WidgetTester tester) async {
      useUHDResolution(tester);
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      for (final canteen in _canteens) {
        expect(find.textContaining(canteen.name), findsWidgets);
      }
    },
  );

  testWidgets(
    'When no connection then error messages shown',
        (WidgetTester tester) async {
      useUHDResolution(tester);
      const errorCanteens = 'Failed to load canteens';

      when(canteenService.getCanteens()).thenThrow(Exception(errorCanteens));

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.textContaining(errorCanteens), findsWidgets);
    },
  );
}
*/
