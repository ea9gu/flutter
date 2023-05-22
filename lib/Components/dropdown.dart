import 'package:ea9gu/constants.dart';
import 'package:flutter/material.dart';

class CustomDropdownButton extends StatelessWidget {
  final String hint;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;

  const CustomDropdownButton({
    required this.hint,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        border: Border.all(color: mainColor, width: 2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: DropdownButton(
        hint: Text(hint),
        underline: SizedBox(),
        dropdownColor: mainColor,
        value: value,
        items: items.map((option) {
          return DropdownMenuItem(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
