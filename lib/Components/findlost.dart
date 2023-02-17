import 'package:flutter/material.dart';

class FindLost extends StatelessWidget {
  final String text;
  final Function() onpress;
  const FindLost({
    super.key,
    required this.text,
    required this.onpress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: onpress,
          child: Text(text),
        )
      ],
    );
  }
}
