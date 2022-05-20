// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_final_fields, unused_field

import 'dart:async';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Animation/fade_animation.dart';
import 'package:flutter_application_1/screens/Register/function.dart';
import 'package:flutter_application_1/tool/validator.dart';

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
            "링크를 클릭해서 인증을 완료하고 아래 버튼을 눌러주세요!",
            style: TextStyle(
              color: Color(0xff0039A4),
            ),
          ),
        ],
      ),
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

  Widget resendButton(Size size) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: size.height * 0.02),
        child: ArgonTimerButton(
          color: Color.fromARGB(255, 48, 94, 180),
          borderRadius: 10,
          height: size.height * 0.06,
          width: size.width * 0.2,
          onTap: (startTimer, btnState) {
            if (btnState == ButtonState.Idle) {
              startTimer(60);
              FirebaseAuth.instance.currentUser!.sendEmailVerification();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('링크를 다시 보냈습니다!'),
                ),
              );
            }
          },
          child: Text(
            "재전송",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          loader: (timeLeft) {
            return Text(
              "$timeLeft",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            );
          },
          roundLoadingShape: false,
        ),
      ),
    );
  }

  Widget registerButton(Size size) {
    return Center(
      child: Container(
        height: size.height * 0.06,
        width: size.width * 0.6,
        margin: EdgeInsets.only(top: size.height * 0.02),
        decoration: BoxDecoration(
          color: Color(0xff0039A4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton(
          onPressed: () {
            if (FirebaseAuth.instance.currentUser!.emailVerified) {
              authStateChanges(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('이메일 인증이 완료되지 않았습니다.'),
                ),
              );
            }
          },
          child: Text(
            "인증 완료",
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
            print(user.emailVerified);
            if (user.emailVerified) {
              timer.cancel();
              setState(
                () {
                  _isUserEmailVerified = user.emailVerified;
                },
              );
              authStateChanges(context);
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
                // decoText(size, "인증번호"),
                // verifyInput(size),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    resendButton(size),
                    SizedBox(width: size.width * 0.05),
                    registerButton(size),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
