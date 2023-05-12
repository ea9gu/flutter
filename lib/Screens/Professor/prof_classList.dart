import 'package:ea9gu/Components/back_button.dart';
import 'package:ea9gu/Screens/Professor/classPlus.dart';
import 'package:ea9gu/Screens/Professor/prof_check.dart';
import 'package:ea9gu/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProclassList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('나의 강좌'),
          centerTitle: true,
          backgroundColor: mainColor,
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {},
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return classPlus();
                          },
                        ),
                      );
                    },
                    icon: Icon(Icons.add_circle_outline, size: 30),
                  ),
                  SizedBox(height: 50),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Check();
                          },
                        ),
                      );
                    },
                    child: Text(
                      "캡스톤디자인과창업프로젝트B",
                      style: TextStyle(
                        fontSize: 18,
                        color: mainColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                      height: 1.0, width: 500.0, color: Color(0xffD8DADC)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}