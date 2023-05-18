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
                      SizedBox(width: 60),
                      GoButton(text: "출석체크하기", onpress: proCheck),
                    ],
                  ),
                  SizedBox(height: 20),
                  AttendanceTable(), // 추가: 출석 체크 표
                ],
              ),
              Column(
                children: [
                  GoButton(text: "임시", onpress: () {}),
                ],
              )
            ]),
          ),
        ],
      ),
    );
  }
}

class AttendanceTable extends StatelessWidget {
  final List<String> studentNumbers = ['2000000', '2000001', '2000002'];
  final List<String> studentNames = ['김이화', '박이화', '최이화'];
  final List<bool> attendances = [false, false, false];
  final List<bool> lates = [false, false, false];
  final List<bool> absences = [true, true, true];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('학번')),
          DataColumn(label: Text('이름')),
          DataColumn(label: Text('출석')),
          DataColumn(label: Text('지각')),
          DataColumn(label: Text('결석')),
        ],
        rows: List<DataRow>.generate(studentNumbers.length, (index) {
          return DataRow(
            cells: [
              DataCell(Text(studentNumbers[index])),
              DataCell(Text(studentNames[index])),
              DataCell(
                Text(attendances[index] ? 'O' : ''),
                onTap: () {
                  // 학번에 해당하는 출석 상태 변경 로직 작성
                  // 예: attendances[index] = !attendances[index];
                },
              ),
              DataCell(
                Text(lates[index] ? 'O' : ''),
                onTap: () {
                  // 학번에 해당하는 지각 상태 변경 로직 작성
                  // 예: lates[index] = !lates[index];
                },
              ),
              DataCell(
                Text(absences[index] ? 'O' : ''),
                onTap: () {
                  // 학번에 해당하는 결석 상태 변경 로직 작성
                  // 예: absences[index] = !absences[index];
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}
