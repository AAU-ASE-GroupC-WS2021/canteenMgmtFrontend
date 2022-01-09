import 'dart:convert';
import 'dart:developer';
import 'dart:html';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;

import 'dish.dart';
import 'qr_demo.dart';



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
  late Future<List<Dish>> futureDishes;

  @override
  void initState() {
    super.initState();
    futureDishes = fetchDishes();
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
                    builder: (context) => const QRViewExample(),
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
                  return Text(snapshot.data!.toString());
                } else if (snapshot.hasError) {
                  print(snapshot.stackTrace);
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),],
        ),
      ),
    );
  }
}

Future<List<Dish>> fetchDishes() async {
  var client = http.Client();
  final response = await client.get(Uri.parse('https://localhost:8443/dish'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final stringData = response.body;
    var responseJson = json.decode(stringData);
    // TODO: might not work - can not really test while http request fails
    return (responseJson as List)
        .map((p) => Dish.fromJson(p))
        .toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load dishes');
  }
}
