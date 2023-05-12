import 'package:ea9gu/Components/gobutton.dart';
import 'package:ea9gu/Components/passwordfield.dart';
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
                    "비밀번호 변경하기",
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
                  child: Text("새로운 비밀번호"),
                )
              ],
            ),
            PasswordField(
              onChanged: (value) {},
            ),
            SizedBox(height: size.height * 0.03),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Text("비밀번호 확인"),
                )
              ],
            ),
            PasswordField(
              onChanged: (value) {},
            ),
            SizedBox(height: size.height * 0.2),
            GoButton(text: "비밀번호 변경하기", onpress: () {}),
          ],
        ),
      ),
    );
  }
}
