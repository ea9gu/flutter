import 'package:ea9gu/constants.dart';
import 'package:flutter/material.dart';

class GoButton extends StatelessWidget {
  final String text;
  final Function() onpress;
  const GoButton({
    super.key,
    required this.text,
    required this.onpress,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(20),
          backgroundColor: mainColor,
          primary: Colors.white,
        ),
        onPressed: onpress,
        child: Text(text),
      ),
    );
  }
}
