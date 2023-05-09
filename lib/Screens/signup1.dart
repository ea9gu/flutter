import 'package:ea9/Components/back_button.dart';
import 'package:ea9/Components/input_box.dart';
import 'package:ea9/Components/next_button.dart';
import 'package:ea9/Screens/signup2.dart';
import 'package:flutter/material.dart';

final InputDeco = InputDecoration(
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(width: 3, color: Color(0xff8685A6))),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(width: 3, color: Color(0xff8685A6))));

class Signup1 extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<Signup1> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  int? id;
  String password = '';
  String password_temp = '';
  String password_confirm = '';
  String email = '';

  //validation functions
  String? validateName(String? value) {
    //이름
    if (value == null || value.isEmpty) {
      return '이름을 입력해주세요.';
    }
    return null;
  }

  String? validateId(String? value) {
    if (value == null || value.isEmpty) {
      return '학번을 입력해주세요.';
    }
    final id = int.tryParse(value);
    if (id == null || value.length != 7) {
      return '유효한 학번을 입력해주세요.';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요.';
    }
    if (value.length < 8) {
      return '비밀번호는 최소 8자리여야 합니다.';
    }
    password_temp = password;
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value != password_temp) {
      return '비밀번호가 다릅니다.';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요.';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return '유효한 이메일을 입력해주세요.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      //두번째 padding <- LIstview에 속함.
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
              Text("이름"), //이름
              SizedBox(height: 5),
              TextFormField(
                decoration: InputDeco,
                validator: validateName,
                onSaved: (value) {
                  name = value!;
                },
              ),
              SizedBox(height: 15),
              Text("학번"), //학번
              SizedBox(height: 5),
              TextFormField(
                decoration: InputDeco,
                validator: validateId,
                onSaved: (value) {
                  id = int.parse(value!);
                },
              ),
              SizedBox(height: 15),
              Text("비밀번호"), //비밀번호
              SizedBox(height: 5),
              TextFormField(
                decoration: InputDeco,
                validator: validatePassword,
                obscureText: false,
                onSaved: (value) {
                  password = value!;
                },
              ),
              SizedBox(height: 15),
              Text("비밀번호 확인"), //비밀번호 확인
              SizedBox(height: 5),
              TextFormField(
                decoration: InputDeco,
                validator: validateConfirmPassword,
                obscureText: false,
                onSaved: (value) {
                  password_confirm = value!;
                },
              ),
              SizedBox(height: 15),
              Text("이메일"), //이메일
              SizedBox(height: 5),
              TextFormField(
                decoration: InputDeco,
                validator: validateEmail,
                onSaved: (value) {
                  email = value!;
                },
              ),
              SizedBox(height: 30),
              Column(children: [
                NextButton(
                    text: "계속",
                    onpress: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // 유효성 검사가 모두 통과된 경우 처리
                        print('Name: $name');
                        print('Username: $id');
                        print('Password: $password');
                        print('Email: $email');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Signup2();
                            },
                          ),
                        );
                      }
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
