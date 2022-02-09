import 'package:flutter/material.dart';

class PrevNextText extends StatelessWidget {
  const PrevNextText(this.text, {Key? key, this.color, required this.callback})
      : super(key: key);

  final String text;
  final Color? color;
  final Function(Direction) callback;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: color,
          ),
          onPressed: () => callback(Direction.previous),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: color,
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.arrow_forward_ios,
            color: color,
          ),
          onPressed: () => callback(Direction.next),
        ),
      ],
    );
  }
}

enum Direction {
  previous,
  next,
}
