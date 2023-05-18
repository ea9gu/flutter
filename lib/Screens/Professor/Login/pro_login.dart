import 'package:ea9gu/Components/accountcheck.dart';
import 'package:ea9gu/Components/findlost.dart';
import 'package:ea9gu/Components/next_button.dart';
import 'package:ea9gu/Components/input_form.dart';
import 'package:ea9gu/Components/passwordfield.dart';
import 'package:ea9gu/Screens/Find/prof_findid.dart';
import 'package:ea9gu/Screens/Find/prof_findpassword.dart';
import 'package:ea9gu/Screens/Professor/Signup/ProSignup1.dart';
import 'package:ea9gu/Screens/Professor/prof_classList.dart';
import 'package:ea9gu/Screens/Student/Login/stu_login.dart';
import 'package:flutter/material.dart';
import 'package:ea9gu/Components/validate.dart';
import 'package:ea9gu/Components/dialog.dart';
import 'package:ea9gu/api/auth_signup.dart';
import 'dart:convert';

class ProfLogin extends StatefulWidget {
  const ProfLogin({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<ProfLogin> {
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
          content: Text('유효하지 않은 이메일이나 비밀번호'),
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

  void onLoginProf() async {
    // TODO: 로그인 버튼 눌렀을 때의 동작 구현
    final String id = idController.text.split('@')[0]; //이메일을 잘라서 id로 저장
    final String password = passwordController.text;
    print('ID: $id, Password: $password');

    final response = await login(id, password);

    final responseData = jsonDecode(response.body);
    final status = responseData['status'];
    print(responseData);

    if (status == "success") {
      if (responseData['flag'] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ProclassList(prof_id: id);
            },
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('로그인 실패'),
            content: Text('잘못된 로그인 페이지입니다. 학생용 로그인은 학생 로그인 페이지에서 진행해주세요'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return stuLogin();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }
    } else {
      // 인증 실패
      DialogFormat.customDialog(
        context: context,
        title: '로그인 실패',
        content: '유효하지 않은 학번이나 비밀번호',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
            height: size.height,
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
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
                              "교수용 로그인하기",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: size.height * 0.07),
                      buildTextFormField(
                        controller: idController,
                        hintText: "이메일",
                        validator: (value) => Validate().validateEmail(value),
                      ),
                      SizedBox(height: size.height * 0.03),
                      buildTextFormField(
                        obscureText: true,
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
                              onLoginProf();
                            }
                          }),
                      SizedBox(height: size.height * 0.03),
                      AccountCheck(
                        onpress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ProSignup1();
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
