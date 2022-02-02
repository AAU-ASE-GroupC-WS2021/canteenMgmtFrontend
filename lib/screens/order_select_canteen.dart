import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../cubits/canteens_cubit.dart';
import '../models/canteen.dart';

class OrderSelectCanteenScreen extends StatelessWidget {
  const OrderSelectCanteenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Initialize Order')),
      body: BlocBuilder<CanteensCubit, List<Canteen>>(
        bloc: GetIt.I.get<CanteensCubit>(),
        builder: (context, canteens) => ListView(
          children: [
            for (final canteen in canteens)
              ListTile(
                title: Text('Canteen #${canteen.id}'),
                subtitle: Text('Name: ${canteen.name}'),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_right),
                  onPressed: () => context.beamToNamed(
                    '/order-select-parameters/${canteen.id}',
                    beamBackOnPop: true,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
