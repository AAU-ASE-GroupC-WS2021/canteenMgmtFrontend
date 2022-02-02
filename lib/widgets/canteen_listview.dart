
import '../models/canteen.dart';
import 'package:flutter/material.dart';

import 'edit_canteen_button.dart';

class CanteenListview extends StatefulWidget {
  const CanteenListview(this.editCallback, this.selectionChangedCallback, {Key? key, required this.canteens})
      : super(key: key);

  final List<Canteen> canteens;
  final Function(Canteen) editCallback;
  final Function(Canteen) selectionChangedCallback;

  @override
  State<CanteenListview> createState() => _CanteenListviewState();
}


class _CanteenListviewState extends State<CanteenListview> {

  var _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return widget.canteens.isNotEmpty ?
    ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: widget.canteens.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            _selectedIndex = index;
            widget.selectionChangedCallback(widget.canteens[index]);
          },
          child: Card(child:ListTile(
            title: Text(widget.canteens[index].name),
            subtitle: Text("${widget.canteens[index].address}\n${widget.canteens[index].numTables} Tables"),
            trailing: EditCanteenButton(widget.editCallback, widget.canteens[index]),
          ),
          ),
        );
      },)
        : const Text('No canteens currently');
  }
}

