import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'beamer_locations.dart';
import 'cubits/auth.dart';
import 'cubits/canteens_cubit.dart';
import 'cubits/dish_cubit.dart';
import 'cubits/filtered_users_cubit.dart';
import 'cubits/menu_cubit.dart';
import 'cubits/order_cubit.dart';
import 'cubits/single_order_cubit.dart';
import 'services/auth/signup_service.dart';
import 'services/avatar_service.dart';
import 'services/canteen_service.dart';
import 'services/dish_service.dart';
import 'services/menu_service.dart';
import 'services/order_service.dart';
import 'services/owner_user_service.dart';
import 'services/util/key_value_shared_prefs.dart';
import 'services/util/key_value_store.dart';
import 'services/util/web/key_value_store_web_stub.dart'
// ignore: uri_does_not_exist
    if (dart.library.html) 'services/web/key_value_store_web.dart'
    show getKeyValueStoreWeb;

Future<void> main() async {
  GetIt.I.registerFactory<DishService>(() => DishService());
  GetIt.I.registerFactory<MenuService>(() => MenuService());
  GetIt.I.registerSingleton<KeyValueStore>(
    kDebugMode && kIsWeb
        ? getKeyValueStoreWeb()
        : SharedPrefsStore(await SharedPreferences.getInstance()),
  );
  GetIt.I.registerFactory<CanteenService>(() => CanteenService());
  GetIt.I.registerFactory<OwnerUserService>(() => OwnerUserService());
  GetIt.I.registerLazySingleton<CanteensCubit>(() => CanteensCubit());
  GetIt.I.registerLazySingleton<FilteredUsersCubit>(() => FilteredUsersCubit());
  GetIt.I.registerLazySingleton<OrderService>(() => OrderService());
  GetIt.I.registerLazySingleton<OrderCubit>(() => OrderCubit());
  GetIt.I.registerLazySingleton<DishCubit>(() => DishCubit());
  GetIt.I.registerLazySingleton<MenuCubit>(() => MenuCubit());
  GetIt.I.registerLazySingleton<SingleOrderCubit>(() => SingleOrderCubit());
  GetIt.I.registerLazySingleton<http.Client>(() => http.Client());
  GetIt.I.registerLazySingleton<SignupService>(() => SignupService());
  GetIt.I.registerLazySingleton<AvatarService>(() => AvatarService());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final beamerDelegate = getBeamerDelegate();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
      ],
      child: MaterialApp.router(
        title: 'Canteen Management',
        routeInformationParser: BeamerParser(),
        routerDelegate: beamerDelegate,
      ),
    );
  }
}
