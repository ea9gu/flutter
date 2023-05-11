import 'package:flutter/material.dart';
import 'package:ea9gu/constants.dart';

class StuCheck extends StatefulWidget {
  const StuCheck({Key? key}) : super(key: key);

  @override
  _StuCheckState createState() => _StuCheckState();
}

class _StuCheckState extends State<StuCheck> with TickerProviderStateMixin {
  bool isCheckButtonEnabled = false;
  bool isCheckButtonPressed = false;
  Color checkButtonBackgroundColor = darkColor;
  Color checkButtonTextColor = Colors.white;
  Color boxBackgroundColor = Colors.white;
  Color boxTextColor = mainColor;

  void toggleCheckButton() {
    setState(() {
      if (!isCheckButtonPressed) {
        isCheckButtonPressed = true;
        checkButtonBackgroundColor = lightColor;
        checkButtonTextColor = Colors.white;
        boxBackgroundColor = mainColor;
        boxTextColor = Colors.white;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TabController _tabController = TabController(length: 2, vsync: this);
    String boxText = isCheckButtonPressed ? '출석체크 완료' : '출석체크를 하세요';
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: size.height * 0.2),
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
            child: TabBarView(
              controller: _tabController,
              children: [
                Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: isCheckButtonEnabled && !isCheckButtonPressed
                            ? () {
                                setState(() {
                                  toggleCheckButton();
                                });
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: checkButtonBackgroundColor,
                          primary: checkButtonTextColor,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                        ),
                        child: Text(
                          isCheckButtonPressed ? '출석체크가 이미 완료되었습니다' : '출석체크하기',
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              isCheckButtonEnabled = true;
                              checkButtonBackgroundColor = darkColor;
                              checkButtonTextColor = Colors.white;
                            });
                          },
                          icon: const Icon(Icons.autorenew),
                          iconSize: 30,
                        ),
                      ),
                    ),
                    SizedBox(height: 80),
                    Container(
                      width: 250,
                      height: 50,
                      color: boxBackgroundColor,
                      child: Center(
                        child: Text(
                          boxText,
                          style: TextStyle(color: boxTextColor),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      width: 250,
                      height: 50,
                      color: mainColor,
                      child: Center(
                        child: Text(
                          "지각, 결석",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
