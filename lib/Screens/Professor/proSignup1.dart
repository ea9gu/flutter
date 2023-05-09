import 'package:ea9/Components/back_button.dart';
import 'package:ea9/Components/next_button.dart';
import 'package:ea9/Screens/Professor/proSignup2.dart';
import 'package:flutter/material.dart';
import 'package:ea9/Components/validate.dart';

final InputDeco = InputDecoration(
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(width: 3, color: Color(0xff8685A6))),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(width: 3, color: Color(0xff8685A6))));

class proSignup1 extends StatefulWidget {
  @override
  SignUpFormState createState() => SignUpFormState();
}

class SignUpFormState extends State<proSignup1> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  int? id;
  final password_controller = TextEditingController();
  String password_confirm = '';
  String email = '';

  String? validateConfirmPassword(String? value) {
    if (value != password_controller.text) {
      return '비밀번호가 다릅니다.';
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
                validator: (value) => Validate().validateName(value),
                onSaved: (value) {
                  name = value!;
                },
              ),
              SizedBox(height: 15),
              Text("학번"), //학번
              SizedBox(height: 5),
              TextFormField(
                decoration: InputDeco,
                validator: (value) => Validate().validateId(value),
                onSaved: (value) {
                  id = int.parse(value!);
                },
              ),
              SizedBox(height: 15),
              Text("비밀번호"), //비밀번호
              SizedBox(height: 5),
              TextFormField(
                controller: password_controller,
                decoration: InputDeco,
                validator: (value) => Validate().validatePassword(value),
                obscureText: false,
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
                validator: (value) => Validate().validateEmail(value),
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
                        // 유효성 검사가 모두 통과된 경우 처리
                        _formKey.currentState!.save();
                        final password = password_controller.text;
                        print('Name: $name');
                        print('Username: $id');
                        print('Password: $password');
                        print('Email: $email');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return proSignup2();
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
