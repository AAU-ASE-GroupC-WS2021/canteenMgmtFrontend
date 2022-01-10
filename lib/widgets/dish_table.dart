import 'package:flutter/material.dart';

import '../models/dish.dart';

class DishTable extends StatelessWidget {
  const DishTable({Key? key, required this.dishes}) : super(key: key);

  final List<Dish> dishes;

  @override
  Widget build(BuildContext context) => DataTable(
        columns: _columns,
        rows: _rows,
        headingTextStyle:
            const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      );

  static const List<DataColumn> _columns = [
    DataColumn(label: Text('Name')),
    DataColumn(label: Text('Price')),
    DataColumn(label: Text('Type')),
  ];

  List<DataRow> get _rows => [
        for (var dish in dishes)
          DataRow(cells: [
            DataCell(Text(dish.name)),
            DataCell(Text(dish.price.toString())),
            DataCell(Text(dish.type)),
          ]),
      ];
}
