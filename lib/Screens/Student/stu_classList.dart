import 'package:ea9gu/Components/back_button.dart';
import 'package:ea9gu/Screens/Student/device.dart';
import 'package:ea9gu/Screens/Student/stu_check.dart';
import 'package:ea9gu/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StuclassList extends StatelessWidget {
  final String student_id;

  StuclassList({required this.student_id});

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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Device(studentId: student_id);
                    },
                  ),
                );
              },
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
                  SizedBox(height: 50),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return StuCheck(buttonText: "캡스톤디자인과창업프로젝트B");
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
