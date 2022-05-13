// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';
import 'package:flutter_application_1/screens/mainScreen/start_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Init/initFirebase.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(milliseconds: 1500),
      () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => (InitFirebase()),
            ),
            (route) => false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      backgroundColor: Color(0xff0039A4),
      body: SafeArea(
        child: Center(
          child: Image.asset(
            'assets/logos/main.png',
            width: size.width * 0.5,
            height: size.height * 0.5,
          ),
        ),
      ),
    );
  }
}
