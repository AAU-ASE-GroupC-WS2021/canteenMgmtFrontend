import '../models/canteen.dart';
import 'package:flutter/material.dart';

class CanteenTable extends StatelessWidget {
  const CanteenTable({Key? key, required this.canteens, required this.showId}) : super(key: key);

  final List<Canteen> canteens;
  final bool showId;

  @override
  Widget build(BuildContext context) {
    return canteens.isNotEmpty ?
      DataTable(
        columns: _columns(),
        rows: _rows(),
        headingTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      )
    : const Text('No canteens currently');
  }

  List<DataColumn> _columns() {
    List<DataColumn> cols = const [
      DataColumn(label: Text('Name')),
      DataColumn(label: Text('Address')),
      DataColumn(label: Text('Num Tables')),
    ];
    if (showId) {
      cols = [const DataColumn(label: Text('ID')), ...cols];
    }
    return cols;
  }

  List<DataRow> _rows() {
    List<DataRow> rows = [];
    for (var canteen in canteens) {
      var cells = [
        DataCell(SelectableText(canteen.name)),
        DataCell(SelectableText(canteen.address)),
        DataCell(SelectableText(canteen.numTables.toString())),
      ];
      if (showId) {
        cells = [DataCell(SelectableText(canteen.id.toString())), ...cells];
      }
      rows.add(DataRow(cells: cells));
    }
    return rows;
  }
}
