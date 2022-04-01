// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_unnecessary_containers, non_constant_identifier_names, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Color/Color.dart';
import 'package:flutter_application_1/Components/main_app_bar.dart';
import 'package:flutter_application_1/Components/setting_button.dart';
import 'package:flutter_application_1/Components/widget_box.dart';

class Mainscreen extends StatefulWidget {
  Mainscreen({Key? key}) : super(key: key);

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  // 기사 많이 나온 종목
  Widget Topstocklist(Size size) {
    return Container(
        child : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '4월 1일, 목요일 (GMT+9) 09:00 기준',
                style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 0.7),
                  fontFamily : 'Content',
                  fontSize : 10,
                  fontWeight : FontWeight.normal,
                  height : 1,
                ),
              )// Firebase 적용 사항
              ,
              Container(
                  width: size.width * 0.9,

                  decoration: widgetBoxDecoration(8, 255, 4, 255),
                  child : Column(
                    children: [ // Firebase 적용 사항
                      Topstock(size), Divider(height : 1,color : GREY),
                      Topstock(size), Divider(height : 1,color : GREY),
                      Topstock(size), Divider(height : 1,color : GREY),
                      Topstock(size), Divider(height : 1,color : GREY),
                      Topstock(size), Divider(height : 1,color : GREY),
                      Topstock(size), Divider(height : 1,color : GREY),
                      Topstock(size), Divider(height : 1,color : GREY),
                      Topstock(size),


                    ],
                  ))
            ]
        )
    );
  }

  Widget Topstock(Size size){
    return Container(
        width: size.width *  0.9,
        height: size.height * 0.37 * 0.1,
        margin : EdgeInsets.only(left : size.width * 0.05, top : size.height * 0.008, right: size.width* 0.03),
        child : Row(
          children: [
            Container(

                child: Text(
                  '삼성 전자',  //Firebase 적용사항
                  style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontFamily: 'ABeeZee',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.2),
                )

            ),
            Container(
                margin: EdgeInsets.only(left: size.width * 0.9 * 0.05),
                alignment: Alignment.center,
                child : Column(
                  children: [
                    Text(
                      '+2.79%', //Firebase 적용사항
                      style: TextStyle(
                          color: CHART_PLUS,
                          fontFamily: 'Content',
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          height: 1.2),),
                    Text(
                      '77,000', //Firebase 적용사항
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'Content',
                          fontSize: 8,
                          fontWeight: FontWeight.normal,
                          height: 1.2),
                    )
                  ],


                )
            ),
            Expanded(

                child: Text(
                  '1,500개', //Firebase 적용사항
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontFamily: 'ABeeZee',
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      height: 1.2),
                )

            ),

          ],
        )
    );
  }

// 주요지수를 알려주는 위젯
  Widget Stockindex(Size size) {
    return Center(
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.3,
        decoration: widgetBoxDecoration(8, 255, 4, 255),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: size.width * 0.25 * 0.1),
              alignment: Alignment.centerLeft,
              width: size.width * 0.9,
              height: size.height * 0.4 * 0.13,
              child: Text(
                '주요 지수',
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
                  height: size.height * 0.4 * 0.08,
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


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: mainAppBar(context, "홈"),
      body: SafeArea(
        child: Column(
          children: [

            SizedBox(height: size.height * 0.03),
            Topstocklist(size),
            SizedBox(height: size.height * 0.045),
            Stockindex(size),


          ],
        ),
      ),
    );
  }
}
