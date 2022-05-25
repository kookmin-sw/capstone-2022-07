// ignore_for_file: prefer_const_constructors_in_immutables, unnecessary_new, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Animation/fade_animation.dart';
import 'package:flutter_application_1/Components/willPop.dart';
import 'package:flutter_application_1/screens/Register/function.dart';
import 'package:flutter_application_1/screens/Register/registerComponents.dart';
import 'package:flutter_application_1/screens/Register/signup/register_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Widget logo(Size size) {
    return Container(
      padding: EdgeInsets.only(left: size.width * 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome to",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: size.width * 0.05,
            ),
          ),
          Text(
            "단타충",
            style: TextStyle(
              color: Color(0xff0039A4),
              fontSize: size.width * 0.07,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget emailInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(15),
              child: TextFormField(
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent)),
                    hintText: "전화번호 혹은 이메일을 입력하세요",
                    hintStyle: TextStyle(color: Colors.grey[400])),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget passwordInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(15),
              child: TextFormField(
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent)),
                    hintText: "비밀번호를 입력하세요",
                    hintStyle: TextStyle(color: Colors.grey[400])),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget googleLoginButton(BuildContext context, Size size) {
    return Center(
      child: Container(
        height: size.height * 0.06,
        width: size.width * 0.8,
        margin: EdgeInsets.only(bottom: size.height * 0.01),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black),
        ),
        child: TextButton(
          onPressed: () async {
            await signInWithGoogle(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/logos/google_logo.svg',
                width: size.width * 0.1,
                height: size.height * 0.03,
              ),
              SizedBox(
                width: size.width * 0.02,
              ),
              Text("구글 계정으로 시작하기",
                  style: TextStyle(
                      fontSize: size.width * 0.035, color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }

  Widget emailLoginButton(BuildContext context, Size size) {
    return Center(
      child: Container(
        height: size.height * 0.06,
        width: size.width * 0.8,
        margin: EdgeInsets.only(bottom: size.height * 0.01),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black),
        ),
        child: OutlinedButton(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.email),
              SizedBox(
                width: size.width * 0.02,
              ),
              Text(
                "이메일 계정으로 시작하기",
                style: TextStyle(
                    fontSize: size.width * 0.035, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        bool result = onWillPop();
        return await Future.value(result);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: FadeAnimation(
            2,
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                logo(size),
                SizedBox(
                  height: size.height * 0.07,
                ),
                Column(
                  children: [
                    googleLoginButton(context, size),
                    emailLoginButton(context, size)
                  ],
                ),
                alreadyLoginButton(context, size)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
