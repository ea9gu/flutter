import 'package:ea9gu/constants.dart';
import 'package:flutter/material.dart';

class AccountCheck extends StatelessWidget {
  final bool login;
  final Function() onpress;
  const AccountCheck({
    super.key,
    this.login = true,
    required this.onpress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "계정이 없으신가요 ? " : "이미 계정이 있으신가요 ? ",
          style: TextStyle(color: mainColor),
        ),
        GestureDetector(
          onTap: onpress,
          child: Text(
            login ? "회원가입하기" : "로그인하기",
            style: TextStyle(color: mainColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
