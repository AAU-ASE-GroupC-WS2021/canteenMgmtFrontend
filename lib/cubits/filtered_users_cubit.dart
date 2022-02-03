import 'package:bloc/bloc.dart';
import 'package:canteen_mgmt_frontend/models/user.dart';
import 'package:canteen_mgmt_frontend/services/owner_user_service.dart';
import 'package:get_it/get_it.dart';

import '../models/canteen.dart';
import '../services/canteen_service.dart';

class FilteredUsersCubit extends Cubit<FilteredUsersState> {
  final OwnerUserService _userService;

  UserType? typeFilter;
  int? canteenIDFilter;

  FilteredUsersCubit()
      : _userService = GetIt.I.get<OwnerUserService>(),
        super(FilteredUsersState(isLoading: true)) {
    refresh();
  }

  Future<void> refresh() async {
    try {
      emit(FilteredUsersState(users: await _getFilteredUsers()));
    } catch (e) {
      emit(FilteredUsersState(exception: e));
    }
  }

  Future<List<User>> _getFilteredUsers() async {
    if (typeFilter != null && canteenIDFilter != null) {
      return _userService.getAllByTypeAndCanteen(typeFilter!, canteenIDFilter!);
    } else if (typeFilter != null && canteenIDFilter == null) {
      return _userService.getAllByType(typeFilter!);
    } else if (typeFilter == null && canteenIDFilter != null) {
      return _userService.getAllByCanteen(canteenIDFilter!);
    }
    return _userService.getAllUsers();
  }

  void setTypeFilter(UserType? typeFilter) {
    this.typeFilter = typeFilter;
  }

  void setCanteenIDFilter(int? canteenIDFilter) {
    this.canteenIDFilter = canteenIDFilter;
  }
}

class FilteredUsersState {
  final List<User>? users;
  final Object? exception;
  final bool isLoading;

  FilteredUsersState({this.users, this.exception, this.isLoading = false});
}