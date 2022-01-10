import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'qr_scanner.dart';

class QrDemoPage extends StatefulWidget {
  const QrDemoPage({Key? key}) : super(key: key);

  static const route = 'qr-demo';

  @override
  State<QrDemoPage> createState() => _QrDemoPageState();
}

class _QrDemoPageState extends State<QrDemoPage> {
  String _result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QR Scanner Demo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Scan QR code'),
              onPressed: () async {
                var result =
                    await Navigator.of(context).pushNamed(QrScannerPage.route);
                if (result is Barcode) {
                  setState(() {
                    _result = result.code ?? '';
                  });
                }
              },
            ),
            const Text('Scanned Result:'),
            Text(_result, style: Theme.of(context).textTheme.headline4),
          ],
        ),
      ),
    );
  }
}
