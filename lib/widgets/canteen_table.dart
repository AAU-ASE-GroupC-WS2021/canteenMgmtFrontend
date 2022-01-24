import '../models/canteen.dart';
import 'package:flutter/material.dart';

class CanteenTable extends StatelessWidget {
  const CanteenTable({Key? key, required this.canteens}) : super(key: key);

  final List<Canteen> canteens;

  @override
  Widget build(BuildContext context) {
    return canteens.isNotEmpty ?
      DataTable(
        columns: _columns,
        rows: _rows,
        headingTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      )
    : const Text('No canteens currently');
  }

  static const List<DataColumn> _columns = [
    DataColumn(label: Text('Name')),
    DataColumn(label: Text('Address')),
    DataColumn(label: Text('Num Tables')),
  ];

  List<DataRow> get _rows => [
        for (var canteen in canteens)
          DataRow(cells: [
            DataCell(Text(canteen.name)),
            DataCell(Text(canteen.address.toString(), softWrap: true,)),
            DataCell(Text(canteen.numTables.toString())),
          ]),
      ];
}
