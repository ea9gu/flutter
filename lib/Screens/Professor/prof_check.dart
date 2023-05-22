import 'package:ea9gu/Components/gobutton.dart';
import 'package:ea9gu/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';

class Check extends StatefulWidget {
  Check({required this.buttonText, Key? key}) : super(key: key);
  final String buttonText;

  @override
  State<Check> createState() => _CheckState();
}

class _CheckState extends State<Check> with TickerProviderStateMixin {
  List<String> optiontime = ['5분', '10분', '15분'];
  List<String> optionlate = ['지각 O', '지각 X'];
  bool flag = false;

  String? selectedOptiontime;
  String? selectedOptionlate;

  final player = AudioPlayer();

  void proCheck() async {
    var url = 'http://localhost:8000/freq/generate-freq/';
    var data = {
      'optiontime': selectedOptiontime,
      'optionlate': selectedOptionlate,
      'course_id': widget.buttonText,
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TabController _tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.buttonText),
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
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            decoration: BoxDecoration(
                                border: Border.all(color: mainColor, width: 2),
                                borderRadius: BorderRadius.circular(25)),
                            child: DropdownButton(
                              hint: Text("출석 시간 설정"),
                              underline: SizedBox(),
                              dropdownColor: mainColor,
                              value: selectedOptiontime,
                              items: optiontime.map((option) {
                                return DropdownMenuItem(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedOptiontime = newValue!;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 30),
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            decoration: BoxDecoration(
                                border: Border.all(color: mainColor, width: 2),
                                borderRadius: BorderRadius.circular(25)),
                            child: DropdownButton(
                              hint: Text("지각 허용 설정"),
                              underline: SizedBox(),
                              dropdownColor: mainColor,
                              value: selectedOptionlate,
                              items: optionlate.map((option) {
                                return DropdownMenuItem(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedOptionlate = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 100),
                      GoButton(
                          text: "출석체크하기",
                          onpress: () {
                            setState(() {
                              flag == false ? flag = true : flag = false;
                            });
                            print(flag);
                            proCheck();
                          }),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
              Column(
                children: [
                  flag == false
                      ? AttendanceTable()
                      : AttendanceTable1() // flag 값에 따라 다른 위젯을 표시
                ],
              )
            ]),
          ),
        ],
      ),
    );
  }
}

class AttendanceTable extends StatefulWidget {
  @override
  _AttendanceTableState createState() => _AttendanceTableState();
}

class _AttendanceTableState extends State<AttendanceTable> {
  List<String> studentNumbers = ['2000000', '2000001', '2000002'];
  List<String> studentNames = ['김이화', '박이화', '최이화'];
  List<String> attendances = ['결석', '결석', '결석'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0), // 행들 사이의 여백 설정
      child: DataTable(
        columns: const <DataColumn>[
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
              '출결',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows: List<DataRow>.generate(studentNumbers.length, (index) {
          return DataRow(
            cells: <DataCell>[
              DataCell(
                Container(
                  alignment: Alignment.center,
                  child: Text(studentNumbers[index]),
                ),
              ),
              DataCell(
                Container(
                  alignment: Alignment.center,
                  child: Text(studentNames[index]),
                ),
              ),
              DataCell(
                DropdownButton<String>(
                  value: attendances[index],
                  onChanged: (String? newValue) {
                    setState(() {
                      attendances[index] = newValue!;
                    });
                  },
                  items: <String>['출석', '지각', '결석'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class AttendanceTable1 extends StatefulWidget {
  @override
  _AttendanceTableState1 createState() => _AttendanceTableState1();
}

class _AttendanceTableState1 extends State<AttendanceTable1> {
  List<String> studentNumbers = ['2000000', '2000001', '2000002'];
  List<String> studentNames = ['김이화', '박이화', '최이화'];
  List<String> attendances = ['출석', '결석', '결석']; // 김이화의 출결 상태를 기본값인 '출석'으로 변경

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0), // 행들 사이의 여백 설정
      child: DataTable(
        columns: const <DataColumn>[
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
              '출결',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows: List<DataRow>.generate(studentNumbers.length, (index) {
          return DataRow(
            cells: <DataCell>[
              DataCell(
                Container(
                  alignment: Alignment.center,
                  child: Text(studentNumbers[index]),
                ),
              ),
              DataCell(
                Container(
                  alignment: Alignment.center,
                  child: Text(studentNames[index]),
                ),
              ),
              DataCell(
                DropdownButton<String>(
                  value: attendances[index],
                  onChanged: (String? newValue) {
                    setState(() {
                      attendances[index] = newValue!;
                    });
                  },
                  items: <String>['출석', '지각', '결석'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
