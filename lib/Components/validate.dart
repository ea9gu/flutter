import 'package:flutter/material.dart';

class Validate {
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
}
