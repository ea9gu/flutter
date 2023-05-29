import 'package:ea9gu/Screens/Professor/Start/prof_body.dart';
import 'package:ea9gu/Components/trans_app_bar.dart';
import 'package:flutter/material.dart';

class ProfStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TransparentAppBar(),
      body: Body(),
    );
  }
}
