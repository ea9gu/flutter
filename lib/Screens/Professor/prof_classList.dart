import 'package:ea9gu/Components/back_button.dart';
import 'package:ea9gu/Screens/Professor/classPlus.dart';
import 'package:ea9gu/Screens/Professor/prof_check.dart';
import 'package:ea9gu/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProclassList extends StatefulWidget {
  final String prof_id;

  ProclassList({required this.prof_id});

  @override
  _ProclassListState createState() => _ProclassListState();
}

class _ProclassListState extends State<ProclassList> {
  String temp = '';

  void _navigateToClassPlus(BuildContext context) async {
    String returnedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => classPlus(
          onDataReturned: (data) {
            setState(() {
              print("전달받은 데이터: $data");
              temp = data;
              print(temp);
            });
          },
        ),
      ),
    );
  }

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
                mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 50),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Check(buttonText: "캡스톤디자인과창업프로젝트B");
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
                    height: 1.0,
                    width: 500.0,
                    color: Color(0xffD8DADC),
                  ),
                  temp != ''
                      ? TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Check(buttonText: temp);
                                },
                              ),
                            );
                          },
                          child: Text(
                            temp,
                            style: TextStyle(
                              fontSize: 18,
                              color: mainColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Container(),
                  temp != ''
                      ? Container(
                          height: 1.0,
                          width: 500.0,
                          color: Color(0xffD8DADC),
                        )
                      : Container(),
                  Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () {
                        _navigateToClassPlus(context);
                      },
                      icon: Icon(
                        Icons.add_circle_outline,
                        size: 30,
                        color: mainColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
