import 'package:ea9gu/Components/back_button.dart';
import 'package:ea9gu/Screens/Professor/classPlus.dart';
import 'package:ea9gu/Screens/Professor/prof_check.dart';
import 'package:ea9gu/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyObject {
  final String buttonText;

  MyObject({required this.buttonText});
}

class ProclassList extends StatelessWidget {
  final String prof_id;

  ProclassList({required this.prof_id});

  final List<MyObject> myArray = [
    MyObject(buttonText: '캡스톤디자인과창업프로젝트B'),
    MyObject(buttonText: '다른 과목'),
    // 다른 객체들을 추가할 수 있습니다.
  ];

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
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: myArray.map((item) {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return Check(
                                            buttonText: item.buttonText);
                                      },
                                    ),
                                  );
                                },
                                child: Text(
                                  item.buttonText,
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: mainColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                                height: 1.0,
                                width: 500.0,
                                color: Color(0xffD8DADC)),
                          ]);
                    }).toList(),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return classPlus(prof_id: prof_id);
                            },
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.add_circle_outline,
                        size: 30,
                        color: mainColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
