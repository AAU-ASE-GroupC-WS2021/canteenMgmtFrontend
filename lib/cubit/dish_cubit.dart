// import 'package:bloc/bloc.dart';
// import 'package:get_it/get_it.dart';
//
// import '../models/dish.dart';
// import '../services/dish_service.dart';
//
// class DishesCubit extends Cubit<_DishDemoScreenState> {
//   final DishService _dishService;
//
//   DishesCubit()
//       : _dishService = GetIt.I.get<DishService>(),
//         super(DishesState(isLoading: true)) {
//     refresh();
//   }
//
//   Future<void> refresh() async {
//     try {
//       emit(DishesState(canteens: await _dishService.getDishes()));
//     } catch (e) {
//       emit(DishesState(exception: e));
//     }
//   }
// }
//
// class DishesState {
//   final List<Dish>? canteens;
//   final Object? exception;
//   final bool isLoading;
//
//   DishesState({this.canteens, this.exception, this.isLoading = false});
// }
