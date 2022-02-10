import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../cubits/canteens_cubit.dart';

class OrderSelectCanteenScreen extends StatefulWidget {
  const OrderSelectCanteenScreen({Key? key}) : super(key: key);

  @override
  State<OrderSelectCanteenScreen> createState() =>
      _OrderSelectCanteenScreenState();
}

class _OrderSelectCanteenScreenState extends State<OrderSelectCanteenScreen> {
  final CanteensCubit canteensCubit = GetIt.I.get<CanteensCubit>();

  @override
  void initState() {
    super.initState();
    canteensCubit.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Initialize Order')),
      body: Center(
        child: BlocBuilder<CanteensCubit, CanteensState>(
          bloc: GetIt.I.get<CanteensCubit>(),
          builder: (context, state) => state.exception != null
              ? Center(
                  child: Text('${state.exception}'),
                )
              : state.isLoading
                  ? const CircularProgressIndicator()
                  : ListView(
                      children: [
                        // helper method to ensure there is no loop over a null object
                        for (final canteen in state.canteens ?? [])
                          ListTile(
                            title: Text('Canteen #${canteen.id}'),
                            subtitle: Text('Name: ${canteen.name}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.arrow_right),
                              onPressed: () => context.beamToNamed(
                                '/create-order/${canteen.id}',
                              ),
                            ),
                          ),
                      ],
                    ),
        ),
      ),
    );
  }
}
