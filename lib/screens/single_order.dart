import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../cubits/order_cubit.dart';
import '../models/order.dart';

class SingleOrderScreen extends StatelessWidget {
  const SingleOrderScreen({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  final int orderId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, List<Order>>(
      bloc: GetIt.I.get<OrderCubit>(),
      builder: (context, orders) {
        final order = orders.firstWhereOrNull((o) => o.id == orderId);

        if (order == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Order not found')),
            body: const Center(child: Text('Nothing here')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text('Order #${order.id}')),
          body: ListView(children: [
            for (final dishEntry in order.dishes.entries)
              ListTile(
                title: Text(dishEntry.key.name),
                subtitle: Text('${dishEntry.value} × \$${dishEntry.key.price}'),
                trailing: Text('${dishEntry.value * dishEntry.key.price}'),
              ),
          ]),
        );
      },
    );
  }
}
