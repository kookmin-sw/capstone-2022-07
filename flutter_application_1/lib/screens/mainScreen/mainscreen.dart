// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_unnecessary_containers, non_constant_identifier_names, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/main_app_bar.dart';
import 'package:flutter_application_1/Components/setting_button.dart';
import 'package:flutter_application_1/Components/widget_box.dart';

class Mainscreen extends StatefulWidget {
  Mainscreen({Key? key}) : super(key: key);

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
// 주요지수를 알려주는 위젯
  Widget Stockindex(Size size) {
    return Center(
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.4,
        decoration: widgetBoxDecoration(8, 255, 4, 255),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: size.width * 0.25 * 0.1),
              alignment: Alignment.centerLeft,
              width: size.width * 0.9,
              height: size.height * 0.4 * 0.13,
              child: Text(
                '주요지수',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'ABeeZee',
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                    height: 1),
              ),
            ),
            Column(
              children: [
                Container(
                  width: size.width * 0.9,
                  height: size.height * 0.4 * 0.15,
                  child: Text(
                    '코스피 종합',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontSize: 17,
                        height: 1),
                  ),
                ),
                Container(
                  height: size.height * 0.4 * 0.15 * 0.5,
                  child: Text(
                    '2,686.3', // Firebase 적용 사항
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(0, 57, 164, 0.9),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1),
                  ),
                ),
                Text(
                  '-3.72', // Firebase 적용 사항
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromRGBO(0, 57, 164, 0.9),
                      fontSize: 12,
                      height: 1),
                ),
                Container(
                  child: Image.asset('assets/charts/chart.png',
                      width: size.width * 0.9 * 0.5,
                      height: size.height * 0.4 * 0.4,
                      fit: BoxFit.fitHeight),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

//뭐넣을지 미정
  Widget Idontknow(Size size) {
    return Container(
        width: size.width * 0.9,
        height: size.height * 0.3,
        decoration: widgetBoxDecoration(8, 255, 4, 255));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: mainAppBar(context, "홈"),
      body: SafeArea(
        child: Column(
          children: [
            Stockindex(size),
            SizedBox(height: size.height * 0.055),
            Idontknow(size)
          ],
        ),
      ),
    );
  }
}
