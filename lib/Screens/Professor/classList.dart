import 'package:ea9gu/Components/back_button.dart';
import 'package:ea9gu/Screens/Professor/classPlus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClassList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
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
              crossAxisAlignment: CrossAxisAlignment.center,
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
                    icon: Icon(Icons.add_circle_outline, size: 30))
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
