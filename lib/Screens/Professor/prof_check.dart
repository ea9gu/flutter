import 'package:ea9gu/Components/gobutton.dart';
import 'package:ea9gu/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:ea9gu/Components/dropdown.dart';

class Check extends StatefulWidget {
  Check({required this.buttonText, Key? key}) : super(key: key);
  final String buttonText;

  @override
  State<Check> createState() => _CheckState();
}

class _CheckState extends State<Check> with TickerProviderStateMixin {
  List<String> optiontime = ['5분', '10분', '15분'];
  List<String> optionlate = ['지각 O', '지각 X'];

  List<String> viewoption = ['날짜별', '학생별'];
  List<String> optiondate = ['1/2', '1/5'];

  String? selectedOptiontime;
  String? selectedOptionlate;

  String? selectedViewOption;
  String? selectedOptiondate;

  String? tab = '출석체크'; //무슨 탭인가

  final player = AudioPlayer();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
    //TabController _tabController = TabController(length: 2, vsync: this);
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
                                hintText: "학번 또는 이름을 검색해주세요.",
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                // 검색어 변경 시 동작
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // 검색 아이콘 클릭 시 동작
                            },
                            icon: Icon(Icons.search),
                            color: mainColor,
                            splashColor: Colors.transparent,
                          ),
                        ],
                      ),
                    )
                ],
              )
            ]),
          ),
        ],
      ),
    );
  }
}
