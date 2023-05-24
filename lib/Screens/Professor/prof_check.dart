import 'package:ea9gu/Components/gobutton.dart';
import 'package:ea9gu/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:ea9gu/Components/dropdown.dart';

class Check extends StatefulWidget {
  final String class_name;
  final String course_id;

  Check({required this.class_name, required this.course_id, Key? key})
      : super(key: key);

  @override
  State<Check> createState() => _CheckState();
}

class _CheckState extends State<Check> with TickerProviderStateMixin {
  List<String> activation_duration = ['5분', '10분', '15분'];
  List<String> optionlate = ['지각 O', '지각 X'];

  List<String> viewoption = ['날짜별', '학생별'];
  List<String> optiondate = ['1/2', '1/5'];

  String? selectedOptiontime;
  String? selectedOptionlate;

  String? selectedViewOption;
  String? selectedOptiondate;

  String? tab = '출석체크'; //무슨 탭인가

  String? studentId;
  Map<String, int> attendanceData = {};
  List<String> attendanceOptions = ['출석', '결석'];
  String? error;

  final player = AudioPlayer();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    attendanceData = {};
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void proCheck() async {
    var selectedOptiontime = '10분'; // 예시로 선택한 값

    if (selectedOptiontime != null) {
      var timeString =
          selectedOptiontime.replaceAll('분', ''); // '10분'에서 '분' 문자열 제거
      var minutes = int.tryParse(timeString); // 문자열을 정수로 변환 (오류 처리 포함)

      if (minutes != null) {
        var url =
            'http://localhost:8000/freq/generate-freq/?course_id=${widget.course_id}&activation_duration=$minutes';

        var response = await http.get(Uri.parse(url));

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
              },
            );
          } else {
            print('Invalid file URL');
          }
        } else {
          print('Failed to send data');
        }
      } else {
        print('Invalid duration');
        // 오류 처리 코드 추가
      }
    } else {
      print('selectedOptiontime is null');
      // 오류 처리 코드 추가
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
                            items: activation_duration,
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
                      GoButton(text: "출석체크하기", onpress: proCheck),
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
                        onChanged: (String? newValue) {
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
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedOptiondate = newValue!;
                                });
                              },
                            ),
                          ],
                        )
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
                                      attendanceData[date] =
                                          newValue == '출석' ? 1 : 0;
                                      print(newValue);
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
