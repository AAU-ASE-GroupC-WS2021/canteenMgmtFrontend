import '../models/menu.dart';
import 'package:flutter/material.dart';

// import '../models/dish.dart';

class MenuTable extends StatelessWidget {
  const MenuTable({Key? key, required this.menus}) : super(key: key);

  final List<Menu> menus;

  @override
  Widget build(BuildContext context) => DataTable(
        columns: _columns,
        rows: _rows,
        headingTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      );

  static const List<DataColumn> _columns = [
    DataColumn(label: Text('Name')),
    DataColumn(label: Text('Price')),
    DataColumn(label: Text('Dishes')),
    DataColumn(label: Text('Day')),
  ];

  List<DataRow> get _rows => [
        for (var menu in menus)
          DataRow(cells: [
            DataCell(Text(menu.name)),
            DataCell(Text(menu.price.toString())),
            DataCell(Text(menu.menuDishNames.toString())),
            DataCell(Text(menu.menuDay)),
          ]),
      ];
}
