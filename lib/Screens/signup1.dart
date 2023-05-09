import 'package:ea9/Components/back_button.dart';
import 'package:ea9/Components/input_box.dart';
import 'package:ea9/Components/next_button.dart';
import 'package:ea9/Screens/signup2.dart';
import 'package:flutter/material.dart';

class Signup1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      //두번째 padding <- LIstview에 속함.
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 80,
              ),
              Text('회원가입하기',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              Center(
                  child: Container(
                      margin: EdgeInsets.all(25),
                      child: Image.asset('assets/bar1.png'))),
              InputBox(text: "이름"),
              SizedBox(height: 15),
              InputBox(text: "아이디"),
              SizedBox(height: 15),
              InputBox(text: "비밀번호"),
              SizedBox(height: 15),
              InputBox(text: "이메일"),
              SizedBox(height: 30),
              Column(children: [
                NextButton(
                    text: "계속",
                    onpress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Signup2();
                          },
                        ),
                      );
                    }),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          "Login",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                  ],
                )
              ])
            ],
          ),
        ),
      ),
    ));
  }
}
