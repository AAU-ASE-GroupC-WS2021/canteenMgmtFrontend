import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';

import '../models/canteen.dart';
import '../services/canteen_service.dart';

class CanteensCubit extends Cubit<List<Canteen>> {
  final CanteenService _canteenService;

  CanteensCubit()
      : _canteenService = GetIt.I.get<CanteenService>(),
        super([]) {
    refresh();
  }

  Future<void> refresh() async => emit(await _canteenService.getCanteens());
}
