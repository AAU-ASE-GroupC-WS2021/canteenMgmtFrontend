import 'package:flutter/material.dart';

class TextHeading extends StatelessWidget {
  const TextHeading(this.content, {Key? key}) : super(key: key);

  final String content;

  @override
  Widget build(BuildContext context) => Text(
      content,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    );
}
