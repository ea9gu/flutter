import 'package:ea9gu/Screens/Student/Start/stu_body.dart';
import 'package:ea9gu/Components/trans_app_bar.dart';
import 'package:flutter/material.dart';

class StuStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TransparentAppBar(),
      body: Body(),
    );
  }
}
