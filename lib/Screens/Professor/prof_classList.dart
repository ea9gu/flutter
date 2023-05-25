import 'package:ea9gu/Components/back_button.dart';
import 'package:ea9gu/Screens/Professor/classPlus.dart';
import 'package:ea9gu/Screens/Professor/prof_check.dart';
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

class ProclassList extends StatefulWidget {
  final String prof_id;

  ProclassList({required this.prof_id});

  @override
  _ProclassListState createState() => _ProclassListState();
}

class _ProclassListState extends State<ProclassList> {
  String prof_id = '';
  List<ClassObject> proClassArray = [];

  @override
  void initState() {
    super.initState();
    prof_id = widget.prof_id;
    fetchProCourses();
  }

  Future<void> fetchProCourses() async {
    print(prof_id);
    final url = Uri.parse(
        'http://13.124.69.1:8000/class/prof-course/?professor_id=${prof_id}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        List<dynamic> courses = data['courses'];

        setState(() {
          proClassArray = courses
              .map((course) => ClassObject(
                  course_id: course['course_id'], class_name: course['name']))
              .toList();
        });
        print(proClassArray);
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
      debugShowCheckedModeBanner: false,
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
                    children: proClassArray.map((item) {
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
