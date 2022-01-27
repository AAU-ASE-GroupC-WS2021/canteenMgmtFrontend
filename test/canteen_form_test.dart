
import 'package:canteen_mgmt_frontend/models/canteen.dart';
import 'package:canteen_mgmt_frontend/widgets/canteen_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Canteen? _returnedCanteen;
  Canteen _initialCanteen = Canteen(name: "SomeCanteen", address: "SomeAddress", numTables: 42);

  Widget testWidgetEmpty = MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Canteen Management'),
      ),
      body: CanteenForm((Canteen c) => {
        _returnedCanteen = c,
      }),
    ),
  );

  Widget testWidgetFilledIn = MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Canteen Management'),
      ),
      body: CanteenForm((Canteen c) => {
        _returnedCanteen = c,
      }, canteen: _initialCanteen,),
    ),
  );

  String _getTextFromTextFormInput(String key) {
    return (find.byKey(Key(key)).evaluate().single.widget as TextFormField).controller!.value.text;
  }

  testWidgets('Check if elements are there', (WidgetTester tester) async {
    await tester.pumpWidget(testWidgetEmpty);
    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(_getTextFromTextFormInput(CanteenForm.keyInputName), "");
    expect(_getTextFromTextFormInput(CanteenForm.keyInputAddress), "");
    expect(_getTextFromTextFormInput(CanteenForm.keyInputNumTables), "");
  });

  testWidgets('When fields empty and button pressed then no submit', (WidgetTester tester) async {
    await tester.pumpWidget(testWidgetEmpty);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle(); // wait until error messages are displayed
    expect(null, _returnedCanteen);
  });

  testWidgets('When fields filled in and button pressed then submit correct data', (WidgetTester tester) async {
    await tester.pumpWidget(testWidgetEmpty);

    await tester.enterText(find.byKey(const Key(CanteenForm.keyInputName)), _initialCanteen.name);
    await tester.enterText(find.byKey(const Key(CanteenForm.keyInputAddress)), _initialCanteen.address);
    await tester.enterText(find.byKey(const Key(CanteenForm.keyInputNumTables)), _initialCanteen.numTables.toString());

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle(); // wait until error messages are displayed

    expect(_returnedCanteen, isNot(null));
    expect(_returnedCanteen!.name, _initialCanteen.name);
    expect(_returnedCanteen!.address, _initialCanteen.address);
    expect(_returnedCanteen!.numTables, _initialCanteen.numTables);
  });

  testWidgets('When initial canteen passed then fields are set', (WidgetTester tester) async {
    await tester.pumpWidget(testWidgetFilledIn);

    expect(_getTextFromTextFormInput(CanteenForm.keyInputName), _initialCanteen.name);
    expect(_getTextFromTextFormInput(CanteenForm.keyInputAddress), _initialCanteen.address);
    expect(_getTextFromTextFormInput(CanteenForm.keyInputNumTables), _initialCanteen.numTables.toString());

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle(); // wait until error messages are displayed


  });

  testWidgets('When non-numeric characters entered into numTables field then no action', (WidgetTester tester) async {
    await tester.pumpWidget(testWidgetEmpty);

    await tester.enterText(find.byKey(const Key(CanteenForm.keyInputNumTables)), 'abc34#yd!');
    expect(_getTextFromTextFormInput(CanteenForm.keyInputNumTables), '34');
  });

  @override
  void tearDown() {
    _returnedCanteen = null;
  }
}
