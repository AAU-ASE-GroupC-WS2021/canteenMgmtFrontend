import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../cubits/order_cubit.dart';
import '../models/order.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: BlocBuilder<OrderCubit, List<Order>>(
        bloc: GetIt.I.get<OrderCubit>(),
        builder: (context, orders) => ListView(
          children: [
            for (final order in orders)
              ListTile(
                title: Text('Order at Canteen #${order.canteenId}'),
                subtitle: Text('Total price: ${order.totalPrice}'),
                trailing: IconButton(
                  icon: const Icon(Icons.qr_code),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Some Order'),
                        content: SizedBox(
                          width: 200,
                          child: QrImage(
                            data: 'canteen-mgmt-order:${order.id}',
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => context.beamToNamed('/order/submit'),
      ),
    );
  }
}
