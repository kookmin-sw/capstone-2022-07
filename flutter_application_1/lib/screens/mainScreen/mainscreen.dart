// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_unnecessary_containers, non_constant_identifier_names, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Color/Color.dart';
import 'package:flutter_application_1/Components/main_app_bar.dart';
import 'package:flutter_application_1/Components/setting_button.dart';

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
                '4월 1일, 목요일 (GMT+9) 09:00 기준', //Firebase 적용 사항
                style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 0.7),
                  fontFamily : 'Content',
                  fontSize : size.width * 0.025,
                  fontWeight : FontWeight.normal,
                  height : 1,
                ),
              )// Firebase 적용 사항
              ,
              Container(
                  width: size.width * 0.9,
                  padding: EdgeInsets.symmetric(vertical: size.height* 0.01),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0,0,0, 0.25),
                          offset: Offset(0, 2),
                          blurRadius: 0)
                    ],
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                  child : Column(
                    children: [ // Firebase 적용 사항
                      Topstock(size, '삼성전자', '+3.1%', 70000, 1213),
                      Topstock(size, '피엔케이피부임상연구센타', '+11.4%', 12230,802 ),
                      Topstock(size, '이승중견기업', '+30%', 9999990, 786),
                      Topstock(size, '동국제약', '-12%', 52000,530 ),
                      Topstock(size, '셀트리온', '+1.2%', 13000, 432),
                      Topstock(size, 'LG에너지솔루션', '-15.5%', 72300,422 ),
                      Topstock(size, '현대엘리베이터', '+9.78%', 34500, 320),
                      Topstock(size, 'SK하이닉스', '+7.78%', 12200,258 ),


                    ],
                  ))
            ]
        )
    );
  }

  Widget Topstock(Size size, String stockname, var stockperc, var stockprice, var newscount ){
    var color;
    if (stockperc[0] == '+') {
      color = CHART_PLUS;
    } else {
      color = CHART_MINUS;
    }

    return Container(
        width: size.width *  0.9,
        height: size.height * 0.37 * 0.1,
        margin : EdgeInsets.only(left : size.width * 0.05, top : size.height * 0.008, right: size.width* 0.03),
        child : Row(
          children: [
            Container(

                child: Text(
                  '${stockname}',  //Firebase 적용사항
                  style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontFamily: 'ABeeZee',
                      fontSize: size.width * 0.035,
                      fontWeight: FontWeight.bold,
                      height: 1.2),
                )

            ),
            Expanded(

              child : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      child : Column(
                        children: [
                          Text(

                            '${stockperc}', //Firebase 적용사항
                            style: TextStyle(
                                color: color,
                                fontFamily: 'Content',
                                fontSize: size.width * 0.03,
                                fontWeight: FontWeight.normal,
                                height: 1.2),),
                          Text(
                            '${stockprice}', //Firebase 적용사항
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'Content',
                                fontSize: size.width * 0.02,
                                fontWeight: FontWeight.normal,
                                height: 1.2),
                          )
                        ],


                      )
                  ),
                  Container(
                      width : size.width * 0.15,
                      child: Text(
                        '${newscount}개', //Firebase 적용사항
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontFamily: 'ABeeZee',
                            fontSize: size.width * 0.035,
                            fontWeight: FontWeight.normal,
                            height: 1.2),
                      )

                  ),

                ],
              )
            )

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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                offset: Offset(0, 2),
                blurRadius: 0)
          ],
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
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
                    fontSize: size.width * 0.045,
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
                        fontSize: size.width * 0.045,
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
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.bold,
                        height: 1),
                  ),
                ),
                Text(
                  '+3.72', // Firebase 적용 사항
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromRGBO(0, 57, 164, 0.9),
                      fontSize: size.width * 0.03,
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
            SizedBox(height: size.height * 0.03),
            Stockindex(size),


          ],
        ),
      ),
    );
  }
}
