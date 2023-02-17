import 'package:ea9gu/Components/gobutton.dart';
import 'package:ea9gu/Screens/Login/login_screen.dart';
import 'package:ea9gu/constants.dart';
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
          Image.asset(
            "assets/images/tuition.png",
            height: size.height * 0.3,
          ),
          Text(
            "교수용",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.2),
          GoButton(
            text: "로그인하기",
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
          SizedBox(height: size.height * 0.03),
          Container(
            width: size.width * 0.8,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.all(20),
                side: BorderSide(
                  color: mainColor,
                  width: 2,
                ),
                primary: Colors.black,
              ),
              onPressed: () {},
              child: Text("회원가입하기"),
            ),
          )
        ],
      ),
    );
  }
}
