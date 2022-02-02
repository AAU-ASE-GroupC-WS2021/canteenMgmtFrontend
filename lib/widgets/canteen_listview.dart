import '../models/canteen.dart';
import 'package:flutter/material.dart';

class CanteenListview extends StatelessWidget {
  const CanteenListview({Key? key, required this.canteens}) : super(key: key);

  final List<Canteen> canteens;

  @override
  Widget build(BuildContext context) {
    return canteens.isNotEmpty ?
    ListView(
        padding: const EdgeInsets.all(8),
        children: _items(),
    )
    : const Text('No canteens currently');
  }

  List<Widget> _items() {
    List<Widget> items = [];
    for (var canteen in canteens) {
      items.add(Card(child:ListTile(
        title: Text(canteen.name),
        subtitle: Text(canteen.address),
        trailing: Icon(Icons.star),)));
    }
    return items;
  }
}
