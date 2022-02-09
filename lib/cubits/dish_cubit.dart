import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';

import '../models/dish.dart';
import '../services/dish_service.dart';

class DishCubit extends Cubit<List<Dish>> {
  final DishService _dishService;

  DishCubit()
      : _dishService = GetIt.I.get<DishService>(),
        super([]) {
    refresh(null);
  }

  Future<void> refresh(String? dishDay) async =>
      emit(await _dishService.fetchDishes(dishDay: dishDay));
}
