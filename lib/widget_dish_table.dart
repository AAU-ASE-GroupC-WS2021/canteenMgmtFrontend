import 'package:flutter/material.dart';

import 'dish.dart';

class DishTableWidget extends StatelessWidget {
  const DishTableWidget({Key? key, required this.dishes}) : super(key: key);

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
      DataColumn(label: Text(
        'Name',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      )),
      DataColumn(label: Text(
        'Price',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      )),
      DataColumn(label: Text(
        'Type',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      )),
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