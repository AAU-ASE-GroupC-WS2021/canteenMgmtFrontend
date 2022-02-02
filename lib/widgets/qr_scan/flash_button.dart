part of 'scanner.dart';

class _QrScannerFlashButton extends StatefulWidget {
  const _QrScannerFlashButton({
    Key? key,
    this.controller,
  }) : super(key: key);

  final QRViewController? controller;

  @override
  _QrScannerFlashButtonState createState() => _QrScannerFlashButtonState();
}

class _QrScannerFlashButtonState extends State<_QrScannerFlashButton> {
  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    if (controller == null) {
      return const IconButton(onPressed: null, icon: Icon(Icons.flash_on));
    }

    return FutureBuilder(
      future: controller.getFlashStatus(),
      builder: (context, AsyncSnapshot<bool?> flashStatus) {
        return IconButton(
          icon: flashStatus.data ?? false
              ? const Icon(Icons.flash_off)
              : const Icon(Icons.flash_on),
          onPressed: () async {
            await controller.toggleFlash();
            //ignore:no-empty-block
            setState(() {});
          },
        );
      },
    );
  }
}
