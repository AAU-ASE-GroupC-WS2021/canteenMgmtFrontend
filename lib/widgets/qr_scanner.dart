import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({
    Key? key,
    this.qrKey,
    this.onScan,
    this.ignoreEmpty = true,
    this.popScreenOnScanResult = false,
  }) : super(key: key);

  final Key? qrKey;
  final Function(BuildContext)? onScan;
  final bool ignoreEmpty;
  final bool popScreenOnScanResult;

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  Barcode? result;
  QRViewController? controller;
  late Key qrKey;

  @override
  void initState() {
    super.initState();
    qrKey = widget.qrKey ?? GlobalKey(debugLabel: 'QR');
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildQrView(context),
        Column(
          children: <Widget>[
            const Expanded(flex: 4, child: SizedBox()),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        if (result != null)
                          Text(
                            'Barcode Type: ${describeEnum(result!.format)}   '
                            'Data: ${result!.code}',
                          )
                        else
                          const Text('Scan a code'),
                        if (!kIsWeb)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.all(8),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await controller?.toggleFlash();
                                    //ignore:no-empty-block
                                    setState(() {});
                                  },
                                  child: FutureBuilder(
                                    future: controller?.getFlashStatus(),
                                    builder: (context, snapshot) {
                                      return Text('Flash: ${snapshot.data}');
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(8),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await controller?.flipCamera();
                                    //ignore:no-empty-block
                                    setState(() {});
                                  },
                                  child: FutureBuilder(
                                    future: controller?.getCameraInfo(),
                                    builder: (context, snapshot) {
                                      return snapshot.data != null
                                          ? Text('Camera facing '
                                              '${describeEnum(snapshot.data!)}')
                                          : const Text('loading');
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (!kIsWeb)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.all(8),
                                child: ElevatedButton(
                                  onPressed: controller?.pauseCamera,
                                  child: const Text(
                                    'pause',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(8),
                                child: ElevatedButton(
                                  onPressed: controller?.resumeCamera,
                                  child: const Text(
                                    'resume',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    // var scanArea = (MediaQuery.of(context).size.width < 400 ||
    //         MediaQuery.of(context).size.height < 400)
    //     ? 150.0
    //     : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      // overlay: QrScannerOverlayShape(
      //   borderColor: Colors.red,
      //   borderRadius: 10,
      //   borderLength: 30,
      //   borderWidth: 10,
      //   cutOutSize: scanArea,
      // ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    Future<Barcode> result = widget.ignoreEmpty
        ? controller.scannedDataStream
            .firstWhere((item) => item.code != null && item.code != '')
        : controller.scannedDataStream.first;

    result.then((scanData) {
      // setState(() {
      //   result = scanData;
      // });

      if (widget.onScan != null) {
        widget.onScan!(context);
      }

      if (widget.popScreenOnScanResult) {
        Navigator.of(context).pop(scanData);
      }
    });
    // controller.scannedDataStream.listen((scanData) {
    //   setState(() {
    //     result = scanData;
    //   });
    // });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
