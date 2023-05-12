import 'package:flutter/material.dart';

class BackButton1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.chevron_left, color: Colors.black))));
  }
}
