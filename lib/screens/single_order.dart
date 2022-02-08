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
    singleOrderCubit.refresh(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order #${widget.orderId}')),
      body: SizedBox(
        width: MediaQuery.of(context).size.height * 0.8,
        child: BlocBuilder<SingleOrderCubit, OrderState>(
          bloc: GetIt.I.get<SingleOrderCubit>(),
          builder: (context, state) => state.exception != null
              ? Center(
                  child: Text('${state.exception}'),
                )
              : state.isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: ListView(children: [
                        for (final dishEntry in state.getOrderDishes())
                          ListTile(
                            title: Text(dishEntry.key.name),
                            subtitle: Text(
                              '${dishEntry.value} × \$${dishEntry.key.price}',
                            ),
                            trailing: Text(
                              '${dishEntry.value * dishEntry.key.price}',
                            ),
                          ),
                      ]),
                    ),
        ),
      ),
    );
  }
}
