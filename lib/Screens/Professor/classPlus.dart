import 'package:ea9gu/Components/back_button.dart';
import 'package:ea9gu/Components/input_box.dart';
import 'package:ea9gu/Components/next_button.dart';
import 'package:ea9gu/Screens/Student/device.dart';
import 'package:flutter/material.dart';

class classPlus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('나의 강좌'),
          centerTitle: true,
          backgroundColor: Color(0xff8685A6),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {},
            )
          ],
        ),
        body: Padding(
          //두번째 padding <- LIstview에 속함.
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(height: 15),
                  InputBox(text: "학수번호"),
                  SizedBox(height: 35),
                  InputBox(text: "출석부 첨부"),
                  SizedBox(height: 50),
                  Column(children: [
                    NextButton(
                        text: "출석부 등록하기/업데이트하기",
                        onpress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return Device();
                              },
                            ),
                          );
                        }),
                  ])
                ],
              ),
            ),
          ),
        ));
  }
}
