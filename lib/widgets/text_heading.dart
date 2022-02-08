import 'package:flutter/material.dart';

class TextHeading extends StatelessWidget {
  const TextHeading(this.content, {Key? key, this.color}) : super(key: key);

  final String content;
  final Color? color;

  @override
  Widget build(BuildContext context) => Text(
        content,
        style:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: color),
      );
}
