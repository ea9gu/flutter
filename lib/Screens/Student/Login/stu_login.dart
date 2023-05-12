import 'package:ea9gu/Components/accountcheck.dart';
import 'package:ea9gu/Components/findlost.dart';
import 'package:ea9gu/Components/next_button.dart';
import 'package:ea9gu/Components/input_form.dart';
import 'package:ea9gu/Components/passwordfield.dart';
import 'package:ea9gu/Screens/Find/prof_findid.dart';
import 'package:ea9gu/Screens/Find/prof_findpassword.dart';
import 'package:ea9gu/Screens/Student/Signup/studentSignup1.dart';
import 'package:ea9gu/Screens/Professor/classList.dart';
import 'package:flutter/material.dart';
import 'package:ea9gu/Components/validate.dart';

class stuLogin extends StatefulWidget {
  const stuLogin({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<stuLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showAuthFailDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('로그인 실패'),
          content: Text('유효하지 않은 학번이나 비밀번호'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void onLoginButtonPressed() {
    // TODO: 로그인 버튼 눌렀을 때의 동작 구현
    final int id = int.parse(idController.text); //이메일을 잘라서 id로 저장
    final String password = passwordController.text;
    print('ID: $id, Password: $password');
    if (id == 1234567 && password == "12345678") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return ClassList();
          },
        ),
      );
    } else {
      // 인증 실패
      _showAuthFailDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(16.0),
            height: size.height,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: size.height * 0.2),
                      Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              "학생용 로그인하기",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: size.height * 0.07),
                      buildTextFormField(
                        controller: idController,
                        hintText: "학번",
                        validator: (value) => Validate().validateId(value),
                      ),
                      SizedBox(height: size.height * 0.03),
                      buildTextFormField(
                        controller: passwordController,
                        hintText: "비밀번호",
                        validator: (value) =>
                            Validate().validatePassword(value),
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
                      NextButton(
                          text: "로그인하기",
                          onpress: () {
                            if (_formKey.currentState!.validate()) {
                              onLoginButtonPressed();
                            }
                          }),
                      SizedBox(height: size.height * 0.03),
                      AccountCheck(
                        onpress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return StudentSignup1();
                              },
                            ),
                          );
                        },
                      ),
                    ]),
              ),
            )));
  }
}
