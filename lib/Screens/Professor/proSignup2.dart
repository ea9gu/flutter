import 'package:ea9gu/Components/back_button.dart';
import 'package:ea9gu/Components/next_button.dart';
import 'package:ea9gu/Screens/classList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class proSignup2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Padding(
        //두번째 padding <- LIstview에 속함.
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 30),
                BackButton1(),
                SizedBox(height: 30),
                Center(
                    child: Container(
                        margin: EdgeInsets.all(25),
                        child: Image.asset('assets/bar2.png'))),
                Container(width: 200, child: Image.asset('assets/phone.png')),
                SizedBox(
                  height: 30,
                ),
                Text('Verify your phone',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Center(
                    child: Container(
                        width: 200,
                        child: Text(
                            'Please enter the 5 digit code sent to 000-0000-0000'))),
                SizedBox(
                  height: 30,
                ),
                Container(
                    child: TextFormField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(width: 3, color: Color(0xff8685A6))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(width: 3, color: Color(0xff8685A6)))),
                )),
                SizedBox(height: 20),
                NextButton(
                    text: "인증하고 계속하기",
                    onpress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ClassList();
                          },
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
