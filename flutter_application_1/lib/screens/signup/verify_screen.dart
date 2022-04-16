// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_final_fields, unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Animation/fade_animation.dart';
import 'package:flutter_application_1/Signin/function.dart';
import 'package:flutter_application_1/screens/signup/register_screen.dart';
import 'package:flutter_application_1/tool/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyScreen extends StatefulWidget {
  VerifyScreen({Key? key}) : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  FocusNode _focus = FocusNode();
  final _verifyKey = GlobalKey<FormState>();
  var _verify = "";
  late Timer _timer;
  bool _isUserEmailVerified = false;

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
              "회원가입",
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
                "입력하신 이메일 계정으로 ",
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                "인증 링크",
                style: TextStyle(
                  color: Color(0xff0039A4),
                ),
              ),
              Text(
                "를 보냈습니다!",
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          Text(
            "링크를 클릭해주세요!",
            style: TextStyle(
              color: Color(0xff0039A4),
            ),
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

  Widget verifyInput(Size size) {
    return Form(
      key: _verifyKey,
      child: Center(
        child: SizedBox(
          height: size.height * 0.1,
          width: size.width * 0.8,
          child: TextFormField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(size.height * 0.02),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]!),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff0039A4)),
                    borderRadius: BorderRadius.circular(10)),
                hintText: "123456",
                hintStyle: TextStyle(color: Colors.grey[400])),
            validator: (value) =>
                CheckValidate().validateVerification(_focus, value!),
            onChanged: (value) {
              _verify = value;
              if (_verifyKey.currentState != null) {
                _verifyKey.currentState!.validate();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget registerButton(Size size) {
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
            "회원가입",
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
  void initState() {
    super.initState();
    Future(
      () async {
        _timer = Timer.periodic(
          Duration(seconds: 1),
          (timer) async {
            await FirebaseAuth.instance.currentUser!.reload();
            var user = FirebaseAuth.instance.currentUser!;
            if (user.emailVerified) {
              setState(
                () {
                  _isUserEmailVerified = user.emailVerified;
                },
              );
              authStateChanges(context);
              timer.cancel();
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(),
        leading: BackButton(
          color: Colors.black,
        ),
        leadingWidth: 70,
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
                decoText(size, "인증번호"),
                verifyInput(size),
                registerButton(size),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
