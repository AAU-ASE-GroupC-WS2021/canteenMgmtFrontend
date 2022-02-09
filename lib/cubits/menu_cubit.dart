import 'package:bloc/bloc.dart';
import '../models/menu.dart';
import '../services/menu_service.dart';
import 'package:get_it/get_it.dart';

class MenuCubit extends Cubit<List<Menu>> {
  final MenuService _menuService;
  String? menuDay;

  MenuCubit()
      : _menuService = GetIt.I.get<MenuService>(),
        super([]) {
    refresh();
  }

  Future<void> refresh() async =>
      emit(await _menuService.fetchMenus(menuDay: menuDay));
}
