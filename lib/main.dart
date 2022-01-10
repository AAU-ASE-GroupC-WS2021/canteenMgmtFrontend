import 'package:canteen_mgmt_frontend/screens/qr_demo.dart';
import 'package:canteen_mgmt_frontend/widgets/dish_table.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'models/dish.dart';
import 'services/dish_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _result = '';
  DishService dishService = DishService();
  late Future<List<Dish>> futureDishes;

  @override
  void initState() {
    super.initState();
    futureDishes = dishService.fetchDishes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                var result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const QrDemoScreen(),
                  ),
                );
                if (result is Barcode) {
                  setState(() {
                    _result = result.code ?? '';
                  });
                }
              },
              child: const Text('qrView'),
            ),
            const Text('Scanned Result:'),
            Text(
              _result,
              style: Theme.of(context).textTheme.headline4,
            ),
            FutureBuilder<List<Dish>>(
              future: futureDishes,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DishTable(dishes: snapshot.data!);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
