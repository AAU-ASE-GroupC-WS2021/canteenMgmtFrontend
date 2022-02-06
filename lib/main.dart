import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'beamer_locations.dart';
import 'cubits/auth.dart';
import 'services/dish_service.dart';
import 'services/key_value_shared_prefs.dart';
import 'services/key_value_store.dart';
import 'services/web/key_value_store_web_stub.dart'
// ignore: uri_does_not_exist
    if (dart.library.html) 'services/web/key_value_store_web.dart'
    show getKeyValueStoreWeb;

Future<void> main() async {
  GetIt.I.registerFactory<DishService>(() => DishService());
  GetIt.I.registerSingleton<KeyValueStore>(
    kDebugMode
        ? getKeyValueStoreWeb()
        : SharedPrefsStore(await SharedPreferences.getInstance()),
  );

  // remove .../#/... from url
  Beamer.setPathUrlStrategy();

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
        title: 'Flutter Demo',
        routeInformationParser: BeamerParser(),
        routerDelegate: beamerDelegate,
      ),
    );
  }
}
