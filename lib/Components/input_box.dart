import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  final String text;
  const InputBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text),
        SizedBox(height: 5),
        TextFormField(
          decoration: InputDecoration(
              hintText: text,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(width: 3, color: Color(0xff8685A6))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(width: 3, color: Color(0xff8685A6)))),
        )
      ],
    );
  }
}
