import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../cubits/dish_cubit.dart';
import '../models/dish.dart';

class DishTableForOrder extends StatefulWidget {
  final Function(Dish) addOrderCallback;

  const DishTableForOrder({Key? key, required this.addOrderCallback})
      : super(key: key);

  @override
  State<DishTableForOrder> createState() => _DishTableForOrderState();
}

class _DishTableForOrderState extends State<DishTableForOrder> {
  final DishCubit dishCubit = GetIt.I.get<DishCubit>();

  @override
  void initState() {
    super.initState();
    dishCubit.refresh();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<DishCubit, List<Dish>>(
        bloc: GetIt.I.get<DishCubit>(),
        builder: (context, dishes) => SizedBox(
          height: 200,
          width: 1000,
          child: ListView(
            scrollDirection: Axis.vertical,
            controller: ScrollController(
              initialScrollOffset: 0.0,
              keepScrollOffset: true,
              debugLabel: 'dish_table_for_ordering_scroll_controller',
            ),
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
                        'Type',
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
                  for (var dish in dishes)
                    TableRow(children: [
                      Column(children: [Text(dish.id.toString())]),
                      Column(children: [Text(dish.name)]),
                      Column(children: [Text(dish.type)]),
                      Column(children: [Text(dish.price.toString())]),
                      Column(children: [
                        TextButton(
                          child: const Icon(Icons.add),
                          onPressed: () {
                            widget.addOrderCallback(dish);
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
