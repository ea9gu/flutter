import 'package:ea9gu/Components/gobutton.dart';
import 'package:ea9gu/Components/inputfield.dart';
import 'package:ea9gu/Screens/Find/changepassword.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.15),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "비밀번호 찾기",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            SizedBox(height: size.height * 0.07),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Text("이름"),
                )
              ],
            ),
            InputField(
              hintText: "이름",
              onChanged: (value) {},
            ),
            SizedBox(height: size.height * 0.03),
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
                  child: Text("이메일"),
                )
              ],
            ),
            InputField(
              hintText: "이메일",
              onChanged: (value) {},
            ),
            SizedBox(height: size.height * 0.2),
            GoButton(
                text: "계속",
                onpress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ChangePassword();
                      },
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
