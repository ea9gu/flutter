import 'package:ea9gu/Components/gobutton.dart';
import 'package:ea9gu/constants.dart';
import 'package:flutter/material.dart';

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
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // SizedBox(width: 40),
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
                      SizedBox(height: size.height * 0.2),
                      GoButton(text: "출석체크하기", onpress: () {}),
                    ],
                  ),
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
