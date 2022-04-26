// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_unnecessary_containers, non_constant_identifier_names, prefer_const_constructors_in_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Color/color.dart';
import 'package:flutter_application_1/Components/main_app_bar.dart';
import 'package:flutter_application_1/Components/setting_button.dart';
import 'package:yahoofin/yahoofin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';




class Mainscreen extends StatefulWidget {
  Mainscreen({Key? key}) : super(key: key);

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final finance = YahooFin();

  Future<void> _getList(List<Map<String, dynamic>> list) async{

      await firestore
          .collection('stock')
          .orderBy("dailynewscount", descending: true)
          .limit(10)
          .get()
          .then((QuerySnapshot qs) {
        qs.docs.forEach((doc) {
          Map<String, dynamic> topnews = doc.data() as Map<String, dynamic>;
          list.add(topnews);
        },
        );
      }
      );

  }

  // 주요지수를 알려주는 위젯
  // 기사 많이 나온 종목

  Widget Topstocklist(Size size, List<Map<String, dynamic>> list) {
    // 특정 콜렉션 참조
    return Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        '', //Firebase 적용 사항
        style: TextStyle(
          color: Color.fromRGBO(0, 0, 0, 0.7),
          fontFamily: 'Content',
          fontSize: size.width * 0.025,
          fontWeight: FontWeight.normal,
          height: 1,
        ),
      ) // Firebase 적용 사항
      ,
      Container(
          width: size.width * 0.9,
          height: size.height * 0.47,
          padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
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
            children: <Widget>[
              for(var item in list)

                  Topstock(size, item['name'], item['perc'], item['price'],
                      item['dailynewscount'])

            ]
          )
    )
    ]));
  }

  Widget Topstock(Size size, String stockname, var stockperc, var stockprice, var newscount) {
    Color color;
    if (stockperc[0] == '+') {
      color = CHART_PLUS;
    } else {
      color = CHART_MINUS;
    }

    return Container(
        width: size.width * 0.9,
        height: size.height * 0.37 * 0.1,
        margin: EdgeInsets.only(
            left: size.width * 0.05,
            top: size.height * 0.008,
            right: size.width * 0.03),
        child: Row(
          children: [
            Container(
                child: Text(
              stockname, //Firebase 적용사항
              style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontFamily: 'ABeeZee',
                  fontSize: size.width * 0.035,
                  fontWeight: FontWeight.bold,
                  height: 1.2),
            )),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    child: Column(
                  children: [
                    Text(
                      '$stockperc', //Firebase 적용사항
                      style: TextStyle(
                          color: color,
                          fontFamily: 'Content',
                          fontSize: size.width * 0.03,
                          fontWeight: FontWeight.normal,
                          height: 1.2),
                    ),
                    Text(
                      '$stockprice', //Firebase 적용사항
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'Content',
                          fontSize: size.width * 0.02,
                          fontWeight: FontWeight.normal,
                          height: 1.2),
                    )
                  ],
                )),
                Container(
                    width: size.width * 0.15,
                    child: Text(
                      '$newscount개', //Firebase 적용사항
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'ABeeZee',
                          fontSize: size.width * 0.035,
                          fontWeight: FontWeight.normal,
                          height: 1.2),
                    )),
              ],
            ))
          ],
        ));
  }

// 주요지수를 알려주는 위젯
  Widget Stockindex(Size size) {

    return Center(
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.27,
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
                    '', // Firebase 적용 사항
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(0, 57, 164, 0.9),
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.bold,
                        height: 1),
                  ),
                ),
                Text(
                  '', // Firebase 적용 사항
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromRGBO(0, 57, 164, 0.9),
                      fontSize: size.width * 0.03,
                      height: 1),
                ),
                Container(
                  // Firebase 적용사항 차트로 변경
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
    List<Map<String, dynamic>> topnewslist = [];
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
      future:     _getList(topnewslist),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (topnewslist.isNotEmpty) {
        return Scaffold(
          appBar: mainAppBar(
            context,
            "홈",
            SettingButton(context),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Topstocklist(size, topnewslist),
                SizedBox(height: size.height * 0.03),
                Stockindex(size),
              ],
            ),
          ),
        );
      } else {
        return Center(child: CircularProgressIndicator());
      }
    },
    );
    }
}
