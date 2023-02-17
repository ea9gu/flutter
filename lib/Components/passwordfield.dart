import 'package:ea9gu/Components/textfield_container.dart';
import 'package:ea9gu/constants.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const PasswordField({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
        child: TextField(
      obscureText: true,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: "비밀번호",
        border: InputBorder.none,
        suffixIcon: Icon(
          Icons.visibility,
          color: mainColor,
        ),
      ),
    ));
  }
}
