import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';

import '../models/dish.dart';
import '../services/dish_service.dart';

class DishCubit extends Cubit<List<Dish>> {
  final DishService _dishService;
  String? dishDay;

  DishCubit()
      : _dishService = GetIt.I.get<DishService>(),
        super([]) {
    refresh();
  }

  Future<void> refresh() async =>
      emit(await _dishService.fetchDishes(dishDay: dishDay));
}
