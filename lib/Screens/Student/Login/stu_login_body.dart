import 'package:ea9gu/Components/accountcheck.dart';
import 'package:ea9gu/Components/findlost.dart';
import 'package:ea9gu/Components/gobutton.dart';
import 'package:ea9gu/Components/inputfield.dart';
import 'package:ea9gu/Components/passwordfield.dart';
import 'package:ea9gu/Screens/Find/prof_findid.dart';
import 'package:ea9gu/Screens/Find/prof_findpassword.dart';
import 'package:ea9gu/Screens/Student/Signup/Signup3/signup3.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.2),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "학생 로그인하기",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              SizedBox(height: size.height * 0.07),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Text("아이디"),
                  )
                ],
              ),
              InputField(
                hintText: "아이디",
                onChanged: (value) {},
              ),
              SizedBox(height: size.height * 0.03),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Text("비밀번호"),
                  )
                ],
              ),
              PasswordField(
                onChanged: (value) {},
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: FindLost(
                        text: "아이디 찾기",
                        onpress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return FindId();
                              },
                            ),
                          );
                        }),
                  ),
                  SizedBox(width: size.width * 0.05),
                  Text("/"),
                  SizedBox(width: size.width * 0.05),
                  Container(
                    child: FindLost(
                        text: "비밀번호 찾기",
                        onpress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return FindPassword();
                              },
                            ),
                          );
                        }),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.2),
              GoButton(text: "로그인하기", onpress: () {}),
              SizedBox(height: size.height * 0.03),
              AccountCheck(
                onpress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Signup3();
                      },
                    ),
                  );
                },
              ),
            ]),
      ),
    );
  }
}
