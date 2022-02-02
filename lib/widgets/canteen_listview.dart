
import '../models/canteen.dart';
import 'package:flutter/material.dart';

import 'edit_canteen_button.dart';

class CanteenListview extends StatefulWidget {
  const CanteenListview(this.editCallback, this.selectionChangedCallback, {Key? key, required this.canteens})
      : super(key: key);

  final List<Canteen> canteens;
  final Function(Canteen) editCallback;
  final Function(Canteen?) selectionChangedCallback;

  @override
  State<CanteenListview> createState() => _CanteenListviewState();
}


class _CanteenListviewState extends State<CanteenListview> {

  var _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return widget.canteens.isNotEmpty ?
    ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: widget.canteens.length,
      itemBuilder: (context, index) {
        return InkWell(
          child: Card(
            child:ListTile(
              title: Text(widget.canteens[index].name),
              subtitle: Text("${widget.canteens[index].address}\n${widget.canteens[index].numTables} Tables"),
              trailing: EditCanteenButton(widget.editCallback, widget.canteens[index]),
              selected: _selectedIndex == index? true: false,
              selectedTileColor: Colors.blue[100],
              onTap: () {
                setState(() {
                  // allow for de-selection if pressed again
                  _selectedIndex = _selectedIndex != index ? index : -1;
                  widget.selectionChangedCallback(_selectedIndex > -1 ? widget.canteens[_selectedIndex] : null);
                });
              },
            ),
          ),
        );
      },)
        : const Center(child: Text('No canteens currently'),);
  }
}

