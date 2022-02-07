import 'package:canteen_mgmt_frontend/models/canteen.dart';
import 'package:canteen_mgmt_frontend/widgets/canteen_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Canteen? _returnedCanteen;
  const _initialCanteen =
      Canteen(name: "SomeCanteen", address: "SomeAddress", numTables: 42);

  Widget testWidgetEmpty = MaterialApp(
    home: Scaffold(
      body: CanteenForm((Canteen c) => _returnedCanteen = c),
    ),
  );

  Widget testWidgetFilledIn = MaterialApp(
    home: Scaffold(
      body: CanteenForm(
        (Canteen c) => _returnedCanteen = c,
        canteen: _initialCanteen,
      ),
    ),
  );

  String _getTextFromTextFormInputAt(int index) {
    return (find.byType(TextFormField).at(index).evaluate().single.widget
            as TextFormField)
        .controller!
        .value
        .text;
  }

  testWidgets('Check if elements are there', (WidgetTester tester) async {
    await tester.pumpWidget(testWidgetEmpty);
    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(_getTextFromTextFormInputAt(0), "");
    expect(_getTextFromTextFormInputAt(1), "");
    expect(_getTextFromTextFormInputAt(2), "");
  });

  testWidgets('When fields empty and button pressed then no submit',
      (WidgetTester tester) async {
    await tester.pumpWidget(testWidgetEmpty);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle(); // wait until error messages are displayed
    expect(null, _returnedCanteen);
  },);

  testWidgets(
      'When fields filled in and button pressed then submit correct data',
      (WidgetTester tester) async {
    await tester.pumpWidget(testWidgetEmpty);

    await tester.enterText(
        find.byType(TextFormField).at(0), _initialCanteen.name,);
    await tester.enterText(
        find.byType(TextFormField).at(1), _initialCanteen.address,);
    await tester.enterText(
        find.byType(TextFormField).at(2), _initialCanteen.numTables.toString(),);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(_returnedCanteen, isNot(null));
    expect(_returnedCanteen!.name, _initialCanteen.name);
    expect(_returnedCanteen!.address, _initialCanteen.address);
    expect(_returnedCanteen!.numTables, _initialCanteen.numTables);
  },);

  testWidgets('When initial canteen passed then fields are set',
      (WidgetTester tester) async {
    await tester.pumpWidget(testWidgetFilledIn);

    expect(_getTextFromTextFormInputAt(0), _initialCanteen.name);
    expect(_getTextFromTextFormInputAt(1), _initialCanteen.address);
    expect(
        _getTextFromTextFormInputAt(2), _initialCanteen.numTables.toString(),);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle(); // wait until error messages are displayed
  },);

  testWidgets(
      'When non-numeric characters entered into numTables field then no action',
      (WidgetTester tester) async {
    await tester.pumpWidget(testWidgetEmpty);

    await tester.enterText(find.byType(TextFormField).at(2), 'abc34#yd!');
    expect(_getTextFromTextFormInputAt(2), '34');
  },);

  tearDown(() {
    _returnedCanteen = null;
  });
}
