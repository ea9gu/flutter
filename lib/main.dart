import 'package:ea9gu/Screens/Professor/Start/prof_start.dart';
import 'package:ea9gu/Screens/Student/Start/stu_start.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: First(),
    ));
  }
}

class First extends StatelessWidget {
  const First({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        //두번째 padding <- LIstview에 속함.
        padding: const EdgeInsets.all(20.0),
        child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              Image.asset('assets/sample.jpg'),
              SizedBox(height: 30),
              Text(
                "Explore the app",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              Container(
                  margin: EdgeInsets.all(10),
                  width: 300,
                  height: 120,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ProfStart();
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffC7C0CE)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                margin: EdgeInsets.all(20),
                                padding: EdgeInsets.only(right: 40),
                                child: Image.asset('assets/professor.png')),
                            Text("교수용")
                          ]))),
              Container(
                  margin: EdgeInsets.all(10),
                  width: 300,
                  height: 120,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return StuStart();
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff5B587E)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                margin: EdgeInsets.all(20),
                                padding: EdgeInsets.only(right: 40),
                                child: Image.asset('assets/student.png')),
                            Text("학생용")
                          ]))),
            ])));
  }
}
