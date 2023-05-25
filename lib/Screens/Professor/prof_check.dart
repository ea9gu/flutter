import 'package:ea9gu/Components/gobutton.dart';
import 'package:ea9gu/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:ea9gu/Components/dropdown.dart';
import 'package:ea9gu/Components/date_attend_table.dart';
import 'package:ea9gu/api/attend_list.dart';

class Check extends StatefulWidget {
  final String class_name;
  final String course_id;

  Check({required this.class_name, required this.course_id, Key? key})
      : super(key: key);

  @override
  State<Check> createState() => _CheckState();
}

class _CheckState extends State<Check> with TickerProviderStateMixin {
  List<String> optiontime = ['5분', '10분', '15분'];
  List<String> optionlate = ['지각 O', '지각 X'];

  List<String> viewoption = ['날짜별', '학생별'];
  List<String> optiondate = [];

  String? selectedOptiontime;
  String? selectedOptionlate;

  String? selectedViewOption;
  String? selectedOptiondate;

  final student_id = '2000001';
  final courseId = '10000-1'; // 가져올 출석 데이터의 과목 ID로 대체해야 합니다.
  final date = '2023-05-23';

  String? tab = '출석체크'; //무슨 탭인가

  Map<String, dynamic> attenddata = {};
  List<dynamic> attendname = [];
  String? studentId;
  Map<String, int> attendanceData = {};
  List<String> attendanceOptions = ['출석', '결석'];
  String? error;

  final player = AudioPlayer();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    getDateData();
    _tabController = TabController(length: 2, vsync: this);
    attendanceData = {};
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void proCheck() async {
    var url = 'http://localhost:8000/freq/generate-freq/';
    var data = {
      'optiontime': selectedOptiontime,
      'optionlate': selectedOptionlate,
      'course_id': widget.course_id,
    };

    var response = await http.post(
      Uri.parse(url),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('Data sent successfully');
      var fileLink = jsonDecode(response.body)['file_url'];
      if (fileLink != null) {
        print(response);
        player.play(AssetSource('audio_20000.wav'));
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('출석체크가 시작되었습니다'),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      } else {
        print('Invalid file URL');
      }
    } else {
      print('Failed to send data');
    }
  }

  void getDateData() async {
    //날짜 리스트
    final courseId = widget.course_id;

    final data = await fetchDateListData(courseId);
    //print(data);
    setState(() {
      optiondate = List<String>.from(data['dates']);
    });
  }

  Future<void> getDateAttendanceData() async {
    //날짜별 출석부
    final courseId = widget.course_id;
    final date = selectedOptiondate;

    if (selectedViewOption == "날짜별") {
      final data = await fetchDateAttendanceData(courseId, date);
      setState(() {
        attenddata = data['attendance_data'];
        attendname = data['student_names'].values.toList();
        print(attendname);
        //print(data);
      });

      if (selectedOptiondate != null) {
        setState(() {});
      }
    }
  }

  void fixAttendance(String courseId, String date, String studentId,
      String beforeAttendance, String afterAttendance) async {
    var url = 'http://localhost:8000/class/fix-attendance/';
    var data = {
      'course_id': courseId,
      'date': date,
      'student_id': studentId,
      'bef_att': beforeAttendance,
      'aft_att': afterAttendance,
    };

    var response = await http.post(
      Uri.parse(url),
      body: data,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      if (responseData.containsKey('success')) {
        print('Attendance fixed successfully.');
      } else if (responseData.containsKey('error')) {
        print(responseData['error']);
      }
    } else {
      print('Failed to fix attendance.');
    }
  }

  void fetchAttendanceData() async {
    var url = 'http://localhost:8000/class/get-attendance-data/';
    var data = {
      'course_id': widget.course_id.toString(),
      'student_id': studentId.toString(),
    };
    print(data);

    try {
      var response = await http.post(
        Uri.parse(url),
        body: data,
      );
      print(response.body);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        var attendanceDataMap =
            Map<String, int>.from(responseData['attendance_data']);
        var attendanceDates = List<String>.from(responseData['dates']);
        setState(() {
          attendanceData = attendanceDataMap;
          attendanceOptions = ['출석', '결석'];
          optiondate = attendanceDates;
          error = null;
        });
      } else {
        setState(() {
          error = 'Failed to fetch attendance data.';
        });
      }
    } catch (e) {
      setState(() {
        error = 'An error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //TabController _tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.class_name),
        centerTitle: true,
        backgroundColor: mainColor,
      ),
      body: Column(
        children: [
          SizedBox(height: size.height * 0.1),
          Container(
            width: MediaQuery.of(context).size.width,
            child: DefaultTabController(
              length: 2,
              initialIndex: 1,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      decoration: BoxDecoration(
                          border: Border.all(color: mainColor),
                          borderRadius: BorderRadius.circular(25)),
                      child: TabBar(
                        controller: _tabController,
                        unselectedLabelColor: mainColor,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: mainColor,
                        ),
                        tabs: [
                          Tab(text: "출석체크"),
                          Tab(text: "출석부"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            child: TabBarView(controller: _tabController, children: [
              Column(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomDropdownButton(
                            hint: "출석 시간 설정",
                            items: optiontime,
                            value: selectedOptiontime,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedOptiontime = newValue!;
                              });
                            },
                          ),
                          SizedBox(width: 30),
                          CustomDropdownButton(
                            hint: "지각 허용 설정",
                            items: optionlate,
                            value: selectedOptionlate,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedOptionlate = newValue!;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 60),
                      GoButton(
                          text: "출석체크하기",
                          onpress: () {
                            proCheck();
                            setState(() {
                              getDateData();
                            });
                          }),
                      AttendanceTable(
                          attendanceData: attenddata,
                          course_id: widget.course_id,
                          name: attendname,
                          date: selectedOptiondate ?? '')
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomDropdownButton(
                        hint: "날짜별/학생별",
                        items: viewoption,
                        value: selectedViewOption,
                        onChanged: (String? newValue) async {
                          setState(() {
                            selectedViewOption = newValue!;
                          });
                        },
                      ),
                      SizedBox(width: 30),
                      if (selectedViewOption == "날짜별")
                        Column(
                          children: [
                            CustomDropdownButton(
                              hint: "날짜",
                              items: optiondate,
                              value: selectedOptiondate,
                              onChanged: (String? newValue) async {
                                setState(() {
                                  selectedOptiondate = newValue!;
                                });
                                await getDateAttendanceData();
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                  if (selectedViewOption == "학생별")
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            decoration: BoxDecoration(
                              border: Border.all(color: mainColor, width: 2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "학번을 입력하세요.",
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  studentId = value;
                                });
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (studentId != null) {
                                fetchAttendanceData();
                              } else {
                                setState(() {
                                  error = 'Please enter a student ID.';
                                });
                              }
                            },
                            icon: Icon(Icons.search),
                            color: mainColor,
                            splashColor: Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  if (selectedViewOption == "날짜별" && selectedOptiondate != null)
                    AttendanceTable(
                        attendanceData: attenddata,
                        course_id: widget.course_id,
                        name: attendname,
                        date: selectedOptiondate ?? ''),
                  if (error != null)
                    Text(
                      'Error: $error',
                      style: TextStyle(color: Colors.red),
                    )
                  else if (attendanceData.isNotEmpty)
                    Expanded(
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('날짜')),
                          DataColumn(label: Text('출석여부')),
                        ],
                        rows: attendanceData.entries.map((entry) {
                          final date = entry.key;
                          String attendanceStatus =
                              entry.value == 1 ? '출석' : '결석';

                          return DataRow(
                            cells: [
                              DataCell(Text(date)),
                              DataCell(
                                DropdownButton(
                                  value: attendanceStatus,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      String beforeAttendance =
                                          entry.value == 1 ? 'True' : 'False';
                                      String afterAttendance =
                                          newValue == '출석' ? 'True' : 'False';
                                      attendanceData[date] =
                                          newValue == '출석' ? 1 : 0;
                                      fixAttendance(
                                          widget.course_id,
                                          date,
                                          studentId!,
                                          beforeAttendance,
                                          afterAttendance);
                                    });
                                  },
                                  items: attendanceOptions.map((option) {
                                    return DropdownMenuItem<String>(
                                      value: option,
                                      child: Text(option),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    )
                  else
                    Text('No attendance data found.'),
                ],
              )
            ]),
          ),
        ],
      ),
    );
  }
}
