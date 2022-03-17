// ignore_for_file: prefer_const_constructors_in_immutables, unnecessary_new, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Animation/fade_animation.dart';
import 'package:flutter_application_1/Components/nav_bar.dart';
import 'package:flutter_application_1/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Widget logo(Size size) {
    return FadeAnimation(
      1.6,
      Text(
        "단타충",
        style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 40,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget emailInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FadeAnimation(
          1.8,
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
        ),
      ],
    );
  }

  Widget passwordInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FadeAnimation(
          1.8,
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
        ),
      ],
    );
  }

  Widget loginButton(Size size) {
    return Column(
      children: <Widget>[
        FadeAnimation(
            2,
            Center(
              child: Container(
                height: size.height * 0.05,
                width: size.width * 0.4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white),
                ),
                child: OutlinedButton(
                  onPressed: () {},
                  child: Text(
                    "로그인",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget signInButton(Size size) {
    return Column(
      children: <Widget>[
        FadeAnimation(
            2,
            Center(
              child: Container(
                height: size.height * 0.05,
                width: size.width * 0.4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white),
                ),
                child: OutlinedButton(
                  onPressed: () {},
                  child: Text(
                    "회원가입",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget appleLoginButton(Size size) {
    return Column(
      children: <Widget>[
        FadeAnimation(
            2,
            Center(
              child: Container(
                height: size.height * 0.05,
                width: size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white),
                ),
                child: OutlinedButton(
                  onPressed: () {
                    FirebaseFirestore.instance.collection("stock").add({
                      'name': "test",
                      'lower': 100000,
                      'upper': '99999999',
                      'volume': 1
                    });
                  },
                  child: Text(
                    "Apple로 로그인",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget googleLoginButton(Size size) {
    return Column(
      children: <Widget>[
        FadeAnimation(
            2,
            Center(
              child: Container(
                height: size.height * 0.05,
                width: size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white),
                ),
                child: OutlinedButton(
                  onPressed: () {},
                  child: Text(
                    "Google 계정으로 로그인",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget tempButton(Size size) {
    return Column(
      children: <Widget>[
        FadeAnimation(
            2,
            Center(
              child: Container(
                height: size.height * 0.05,
                width: size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white),
                ),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MyApp();
                        },
                      ),
                    );
                  },
                  child: Text(
                    "관심 종목",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          logo(size),
          emailInput(),
          passwordInput(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [loginButton(size), signInButton(size)],
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            children: [appleLoginButton(size), googleLoginButton(size)],
          ),
        ],
      ),
      bottomNavigationBar: Navbar(),
    );
  }
}
