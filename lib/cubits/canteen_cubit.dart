import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';

import '../models/canteen.dart';
import '../services/canteen_service.dart';

class CanteensCubit extends Cubit<CanteensState> {
  final CanteenService _canteenService;

  CanteensCubit()
      : _canteenService = GetIt.I.get<CanteenService>(),
        super(CanteensState(isLoading: true)) {
    refresh();
  }

  Future<void> refresh() async {
    try {
      emit(CanteensState(canteens: await _canteenService.getCanteens()));
    } catch (e) {
      emit(CanteensState(exception: e));
    }
  }
}

class CanteensState {
  final List<Canteen>? canteens;
  final Object? exception;
  final bool isLoading;

  CanteensState({this.canteens, this.exception, this.isLoading = false});
}
