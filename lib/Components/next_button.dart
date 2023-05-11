import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  final String text;
  final Function() onpress;
  const NextButton({super.key, required this.text, required this.onpress});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 500,
        height: 60,
        child: ElevatedButton(
            onPressed: onpress,
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular((10))),
                backgroundColor: Color(0xff8685A6)),
            child: Text(text)));
  }
}
