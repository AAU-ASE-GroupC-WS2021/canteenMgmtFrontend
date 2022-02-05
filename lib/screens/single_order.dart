import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../cubits/single_order_cubit.dart';

class SingleOrderScreen extends StatefulWidget {
  final int orderId;

  const SingleOrderScreen({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  @override
  State<SingleOrderScreen> createState() => _SingleOrderScreenState();
}

class _SingleOrderScreenState extends State<SingleOrderScreen> {
  final SingleOrderCubit singleOrderCubit = GetIt.I<SingleOrderCubit>();

  @override
  void initState() {
    super.initState();
    singleOrderCubit.setOrderId(widget.orderId);
    singleOrderCubit.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SingleOrderCubit, OrderState>(
      bloc: singleOrderCubit,
      builder: (context, state) {
        final order = state.order;
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
