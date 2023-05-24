import 'package:ea9gu/Components/back_button.dart';
import 'package:ea9gu/Screens/Student/device.dart';
import 'package:ea9gu/Screens/Student/stu_check.dart';
import 'package:ea9gu/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ClassObject {
  final String class_name;
  final String course_id;

  ClassObject({required this.course_id, required this.class_name});
}

class StuclassList extends StatefulWidget {
  final String student_id;

  StuclassList({required this.student_id});

  @override
  _StuclassListState createState() => _StuclassListState();
}

class _StuclassListState extends State<StuclassList> {
  String student_id = '';
  List<ClassObject> classArray = [];

  @override
  void initState() {
    super.initState();
    student_id = widget.student_id;
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    print(student_id);
    final url = Uri.parse(
        'http://10.0.2.2:8000/class/student-course/?student_id=${student_id}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        List<dynamic> courses = data['courses'];

        setState(() {
          classArray = courses
              .map((course) => ClassObject(
                  course_id: course['course_id'], class_name: course['name']))
              .toList();
        });
      } else {
        // Handle API error
      }
    } catch (e) {
      // Handle network or connection error
    }
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
                  Column(
                    children: classArray.map((item) {
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
                                        return StuCheck(
                                          student_id: student_id,
                                          class_name: item.class_name,
                                          course_id: item.course_id,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Text(
                                  item.class_name,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
