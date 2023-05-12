import 'package:ea9gu/Components/textfield_container.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  const InputField({
    super.key,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
