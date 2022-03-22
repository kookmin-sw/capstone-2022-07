import 'package:flutter/material.dart';

class CheckValidate {
  String? validateEmailOrPhone(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return '이메일 또는 전화번호를 입력하세요.';
    } else {
      String phonePattern =
          r'((01[1|6|7|8|9])[1-9]+[0-9]{6,7})|(010[1-9][0-9]{7})$';
      String emailPattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExpPhone = RegExp(phonePattern);
      RegExp regExpEmail = RegExp(emailPattern);
      if (!regExpPhone.hasMatch(value) && !regExpEmail.hasMatch(value)) {
        focusNode.requestFocus(); //포커스를 해당 textformfield에 맞춘다.
        return '잘못된 이메일 또는 전화번호 형식입니다.';
      } else {
        if (regExpEmail.hasMatch(value)) {
          return null;
        } else if (regExpPhone.hasMatch(value)) {
          return null;
        }
        return null;
      }
    }
  }

  String? validateEmail(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return '이메일을 입력하세요.';
    } else {
      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus(); //포커스를 해당 textformfield에 맞춘다.
        return '잘못된 이메일 형식입니다.';
      } else {
        return null;
      }
    }
  }

  String? validatePassword(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return '비밀번호를 입력하세요.';
    } else {
      String pattern =
          r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,}$';
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus();
        return '문자, 특수문자, 숫자 포함 8자 이상으로 입력하세요.';
      } else {
        return null;
      }
    }
  }

  String? validateNickname(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return '닉네임을 입력하세요.';
    } else {
      String pattern = r'^[a-zA-Z0-9ㄱ-ㅎ가-힣]{3,8}$';
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus();
        return '3자 이상 8자 이내의 한글, 영어, 숫자로만 입력하세요.';
      } else {
        return null;
      }
    }
  }

  String? validateVerification(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return '인증번호를 입력하세요';
    } else {
      String pattern = r'^[0-9]{6}$';
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus();
        return '올바른 인증번호를 입력하세요';
      } else {
        return null;
      }
    }
  }
}
