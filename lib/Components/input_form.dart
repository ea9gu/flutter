import 'package:flutter/material.dart';

final InputDeco = InputDecoration(
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(width: 3, color: Color(0xff8685A6))),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(width: 3, color: Color(0xff8685A6))));

Widget buildTextFormField({
  required String hintText,
  String? Function(String?)? validator,
  void Function(String?)? onSaved,
  bool obscureText = false,
  TextEditingController? controller,
}) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(hintText),
    SizedBox(height: 5),
    TextFormField(
      decoration: InputDeco.copyWith(
        hintText: hintText,
      ),
      validator: validator,
      onSaved: onSaved,
      obscureText: obscureText,
      controller: controller,
    )
  ]);
}
