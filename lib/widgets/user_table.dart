import '../models/user.dart';
import 'package:flutter/material.dart';

class UserTable extends StatelessWidget {
  const UserTable({Key? key, required this.users}) : super(key: key);

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    return users.isNotEmpty ?
      DataTable(
        columns: _columns(),
        rows: _rows(),
        headingTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      )
    : const Text('No users currently');
  }

  List<DataColumn> _columns() {
    List<DataColumn> cols = [
      const DataColumn(label: Text('Username')),
      const DataColumn(label: Text('Type')),
    ];
    return cols;
  }

  List<DataRow> _rows() {
    List<DataRow> rows = [];
    for (var user in users) {
      var cells = [
        DataCell(SelectableText(user.username)),
        DataCell(SelectableText(user.type.name)),
      ];
      rows.add(DataRow(cells: cells));
    }
    return rows;
  }
}
