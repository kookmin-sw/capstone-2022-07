// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_final_fields, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Animation/fade_animation.dart';
import 'package:flutter_application_1/screens/signup/register_screen.dart';
import 'package:flutter_application_1/tool/validator.dart';

class FindPasswordInputNewPassword extends StatefulWidget {
  FindPasswordInputNewPassword({Key? key}) : super(key: key);

  @override
  State<FindPasswordInputNewPassword> createState() =>
      _FindPasswordInputNewPasswordState();
}

class _FindPasswordInputNewPasswordState
    extends State<FindPasswordInputNewPassword> {
  var _password = "";
  var _checkPassword = "";
  final _passwordKey = GlobalKey<FormState>();
  final _checkPasswordKey = GlobalKey<FormState>();

  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _checkPasswordFocusNode = FocusNode();

  Widget informaion(Size size) {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.1),
      padding: EdgeInsets.only(left: size.width * 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: size.height * 0.02),
            child: Text(
              "비밀번호를 잊으셨나요?",
              style: TextStyle(
                color: Color(0xff0039A4),
                fontSize: size.width * 0.07,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              Text(
                "새 ",
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                "비밀번호",
                style: TextStyle(
                  color: Color(0xff0039A4),
                ),
              ),
              Text(
                " 를 입력해주세요!",
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget decoText(Size size, String text) {
    return Container(
      padding: EdgeInsets.only(
          top: size.height * 0.01,
          left: size.width * 0.1,
          bottom: size.height * 0.01),
      child: Text(text),
    );
  }

  Widget passwordInput(Size size) {
    return Form(
      key: _passwordKey,
      child: Center(
        child: SizedBox(
          height: size.height * 0.1,
          width: size.width * 0.8,
          child: TextFormField(
            obscureText: true,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(size.height * 0.02),
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff0039A4)),
                    borderRadius: BorderRadius.circular(10)),
                hintText: "ㆍㆍㆍㆍㆍㆍㆍㆍ",
                hintStyle: TextStyle(color: Colors.grey[400])),
            validator: (value) =>
                CheckValidate().validatePassword(_passwordFocusNode, value!),
            onChanged: (value) {
              _password = value;
              if (_passwordKey.currentState != null) {
                _passwordKey.currentState!.validate();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget checkPasswordInput(Size size) {
    return Form(
      key: _checkPasswordKey,
      child: Center(
        child: SizedBox(
          height: size.height * 0.1,
          width: size.width * 0.8,
          child: TextFormField(
            obscureText: true,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(size.height * 0.02),
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff0039A4)),
                    borderRadius: BorderRadius.circular(10)),
                hintText: "ㆍㆍㆍㆍㆍㆍㆍㆍ",
                hintStyle: TextStyle(color: Colors.grey[400])),
            validator: (value) {
              if (value!.isEmpty) {
                return '비밀번호를 입력하세요.';
              }
              if (value != _password) return '비밀번호가 일치하지 않습니다.';
              return null;
            },
            onChanged: (value) {
              _checkPassword = value;
              if (_checkPasswordKey.currentState != null) {
                _checkPasswordKey.currentState!.validate();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget confirmButton(Size size) {
    return Center(
      child: Container(
        height: size.height * 0.06,
        width: size.width * 0.8,
        margin: EdgeInsets.only(top: size.height * 0.02),
        decoration: BoxDecoration(
          color: Color(0xff0039A4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return RegisterScreen();
                },
              ),
            );
          },
          child: Text(
            "확인",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.035,
                color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: FadeAnimation(
            2,
            Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                informaion(size),
                SizedBox(height: size.height * 0.05),
                decoText(size, "새로운 비밀번호"),
                passwordInput(size),
                decoText(size, "비밀번호 확인"),
                checkPasswordInput(size),
                confirmButton(size),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
