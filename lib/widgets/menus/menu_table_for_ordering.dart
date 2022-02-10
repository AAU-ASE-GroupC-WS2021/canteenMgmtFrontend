import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../cubits/menu_cubit.dart';
import '../../models/menu.dart';

class MenuTableForOrder extends StatefulWidget {
  final Function(Menu) addOrderCallback;
  final bool showAdd;

  const MenuTableForOrder({
    Key? key,
    required this.addOrderCallback,
    this.showAdd = true,
  }) : super(key: key);

  @override
  State<MenuTableForOrder> createState() => _MenuTableForOrderState();
}

class _MenuTableForOrderState extends State<MenuTableForOrder> {
  final MenuCubit menuCubit = GetIt.I.get<MenuCubit>();

  @override
  void initState() {
    super.initState();
    menuCubit.refresh();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<MenuCubit, List<Menu>>(
        bloc: GetIt.I.get<MenuCubit>(),
        builder: (context, menus) => SizedBox(
          height: 200,
          width: 1000,
          child: ListView(
            controller: ScrollController(
              initialScrollOffset: 0.0,
              keepScrollOffset: true,
              debugLabel: 'menu_table_for_ordering_scroll_controller',
            ),
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Table(
                defaultColumnWidth: const FixedColumnWidth(150.0),
                border: TableBorder.all(
                  color: Colors.black,
                  style: BorderStyle.solid,
                  width: 1,
                ),
                children: [
                  TableRow(children: [
                    Column(children: const [
                      Text(
                        'ID',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
                    Column(children: const [
                      Text(
                        'Name',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
                    Column(children: const [
                      Text(
                        'Dishes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
                    Column(children: const [
                      Text(
                        'Price',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
                    if (widget.showAdd)
                      Column(children: const [
                        Text(
                          'Add to order',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]),
                  ]),
                  for (var menu in menus)
                    TableRow(children: [
                      Column(children: [Text(menu.id.toString())]),
                      Column(children: [Text(menu.name)]),
                      Column(children: [Text(menu.menuDishNames.toString())]),
                      Column(children: [Text(menu.price.toString())]),
                      if (widget.showAdd)
                        Column(children: [
                          TextButton(
                            child: const Icon(Icons.add),
                            onPressed: () {
                              widget.addOrderCallback(menu);
                            },
                          ),
                        ]),
                    ]),
                ],
              ),
            ],
          ),
        ),
      );
}
