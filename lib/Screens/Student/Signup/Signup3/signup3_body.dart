import 'package:ea9gu/Components/accountcheck.dart';
import 'package:ea9gu/Components/gobutton.dart';
import 'package:ea9gu/Components/inputfield.dart';
import 'package:ea9gu/Screens/Professor/Login/prof_login_screen.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Text("닉네임"),
              )
            ],
          ),
          InputField(
            hintText: "닉네임",
            onChanged: (value) {},
          ),
          SizedBox(height: size.height * 0.03),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Text("학번"),
              )
            ],
          ),
          InputField(
            hintText: "학번",
            onChanged: (value) {},
          ),
          SizedBox(height: size.height * 0.2),
          GoButton(text: "계정 생성하기", onpress: () {}),
          SizedBox(height: size.height * 0.03),
          AccountCheck(
            login: false,
            onpress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Login();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
