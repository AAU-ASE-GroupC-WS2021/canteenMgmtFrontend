import 'package:flutter/material.dart';

import '../models/dish.dart';

class DishTable extends StatelessWidget {
  static const columnHeadStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  const DishTable({Key? key, required this.dishes}) : super(key: key);

  final List<Dish> dishes;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: _createColumns(),
      rows: _createRows(),
    );
  }

  List<DataColumn> _createColumns() {
    return const [
      DataColumn(label: Text('Name', style: columnHeadStyle)),
      DataColumn(label: Text('Price', style: columnHeadStyle)),
      DataColumn(label: Text('Type', style: columnHeadStyle)),
    ];
  }

  List<DataRow> _createRows() {
    List<DataRow> rows = [];

    for (var dish in dishes) {
      rows.add(DataRow(cells: [
        DataCell(Text(dish.name)),
        DataCell(Text(dish.price.toString())),
        DataCell(Text(dish.type)),
      ]));
    }

    return rows;
  }
}
