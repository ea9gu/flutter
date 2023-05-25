import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AttendanceTable extends StatefulWidget {
  final String course_id;
  final Map<String, dynamic> attendanceData;
  final List<dynamic> name;
  final String date;

  AttendanceTable(
      {required this.attendanceData,
      required this.course_id,
      required this.name,
      required this.date});

  @override
  _AttendanceTableState createState() => _AttendanceTableState();
}

class _AttendanceTableState extends State<AttendanceTable> {
  late List<String> studentNumbers;
  late List<Map<String, dynamic>> attendanceStatusList;
  late List<dynamic> studentNames;

  @override
  void initState() {
    super.initState();
    studentNames = [];
    updateAttendanceData();
    //print(widget.name);
  }

  @override
  void didUpdateWidget(covariant AttendanceTable oldWidget) {
    if (widget.attendanceData != oldWidget.attendanceData) {
      updateAttendanceData();
    }
    super.didUpdateWidget(oldWidget);
  }

  void updateAttendanceData() {
    studentNumbers = widget.attendanceData.keys.toList();
    attendanceStatusList = generateAttendanceStatusList();
    studentNames = widget.name;
  }

  List<Map<String, dynamic>> generateAttendanceStatusList() {
    return studentNumbers.map((studentNumber) {
      dynamic attendanceStatus = widget.attendanceData[studentNumber];
      String attendanceText = attendanceStatus == 1 ? '출석' : '결석';
      return {
        'studentNumber': studentNumber,
        'attendanceText': attendanceText,
        'isAttendanceChanged': false,
      };
    }).toList();
  }

  void updateAttendanceStatus(int index, String? newStatus) {
    setState(() {
      attendanceStatusList[index]['attendanceText'] = newStatus ?? '';
      attendanceStatusList[index]['isAttendanceChanged'] = true;
      fixAttendanceStatus(); // Call fixAttendanceStatus() here
    });
  }

  void fixAttendanceStatus() async {
    for (int i = 0; i < attendanceStatusList.length; i++) {
      if (attendanceStatusList[i]['isAttendanceChanged']) {
        String studentId = attendanceStatusList[i]['studentNumber'];
        String newAttendanceText = attendanceStatusList[i]['attendanceText'];
        String isAttendance = newAttendanceText == '출석' ? "True" : "False";
        String beforeAttendance;

        if (isAttendance == "True") {
          beforeAttendance = "False";
        } else {
          beforeAttendance = "True";
        }

        // Send POST request to fix attendance
        try {
          final body = {
            'course_id': '10000-1',
            'date': widget.date,
            'student_id': studentId,
            'bef_att': beforeAttendance,
            'aft_att': isAttendance,
          };
          print(body);
          var response = await http.post(
            Uri.parse('http://10.0.2.2:8000/class/fix-attendance/'),
            body: body,
          );

          if (response.statusCode == 200) {
            var responseData = json.decode(response.body);
            if (responseData.containsKey('success')) {
              print('Attendance fixed successfully.');
              // Optionally, you can update the UI or show a success message
            } else if (responseData.containsKey('error')) {
              print('Error: ${responseData['error']}');
              // Optionally, you can show an error message
            }
          } else {
            print('Error: ${response.reasonPhrase}');
            // Optionally, you can show an error message
          }
        } catch (e) {
          print('Exception: $e');
          // Handle exception
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: DataTable(
        columns: <DataColumn>[
          DataColumn(
            label: Text(
              '학번',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              '이름',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              '출석여부',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows: List<DataRow>.generate(studentNumbers.length, (index) {
          String studentNumber = studentNumbers[index];
          String studentName = studentNames[index];
          String? attendanceText =
              attendanceStatusList[index]['attendanceText'];

          return DataRow(
            cells: [
              DataCell(
                Container(
                  alignment: Alignment.center,
                  child: Text(studentNumber),
                ),
              ),
              DataCell(
                Container(
                  alignment: Alignment.center,
                  child: Text(studentName),
                ),
              ),
              DataCell(
                Container(
                  alignment: Alignment.center,
                  child: DropdownButton<String>(
                    value: attendanceText,
                    items: <String>['출석', '결석'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        updateAttendanceStatus(index, newValue);
                      }
                    },
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
