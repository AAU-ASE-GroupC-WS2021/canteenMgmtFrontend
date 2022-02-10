import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../cubits/order_cubit.dart';
import '../../models/orders/order.dart';
import '../../services/util/order_qr_code.dart';
import '../../widgets/orders/qr_popup.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GetIt.I.get<OrderCubit>().refresh();
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: BlocBuilder<OrderCubit, List<Order>>(
        bloc: GetIt.I.get<OrderCubit>(),
        builder: (context, orders) => ListView(children: [
          for (final order in orders) _OrderListTile(order: order),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => context.beamToNamed('/order-select-canteen'),
      ),
    );
  }
}

class _OrderListTile extends StatelessWidget {
  const _OrderListTile({
    Key? key,
    required this.order,
  }) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Order at Canteen #${order.canteenId}'),
      subtitle: Text('Total price: ${order.totalPrice}'),
      trailing: IconButton(
        icon: const Icon(Icons.qr_code),
        onPressed: () {
          if (order.tokenIsAvailable) {
            showDialog(
              context: context,
              builder: (context) => QrPopup(token: order.token!),
            );
          } else {
            GetIt.I.get<OrderCubit>().refresh();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('No code available, please refresh!'),
            ));
          }
        },
      ),
    );
  }
}
