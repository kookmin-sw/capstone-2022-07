// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Init/initFirebase.dart';

void main() => runApp(MaterialApp(
      home: SplashPage(),
    ));

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1500), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => InitFirebase()));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
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
      ),
    );
  }
}
