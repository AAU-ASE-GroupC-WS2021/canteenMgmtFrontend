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
    List<DataColumn> cols = [
      if (showId)
        const DataColumn(label: Text('ID')),
      const DataColumn(label: Text('Name')),
      const DataColumn(label: Text('Address')),
      const DataColumn(label: Text('Num Tables')),
    ];
    return cols;
  }

  List<DataRow> _rows() {
    List<DataRow> rows = [];
    for (var canteen in canteens) {
      var cells = [
        if (showId)
          DataCell(SelectableText(canteen.id.toString())),
        DataCell(SelectableText(canteen.name)),
        DataCell(SelectableText(canteen.address)),
        DataCell(SelectableText(canteen.numTables.toString())),
      ];
      rows.add(DataRow(cells: cells));
    }
    return rows;
  }
}
