// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(stock());

class stock extends StatefulWidget {
  stock({Key? key}) : super(key: key);

  @override
  State<stock> createState() => _stockState();
}

class _stockState extends State<stock> {

  Widget stock(Size size) {
    return Container(

        height: 140,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: size.width/3,

                padding : EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text('삼성전자',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color : Color(0xFF2C2CDC),
                        letterSpacing: 0,
                      ) , ),
                    Text('1020000',
                      style: TextStyle(
                        fontSize: 15,
                        color : Color(0x4C100F0F),
                      )), //종목 가격
                    Text('+10%')//전일 대비 등락ㄱ율     @
                  ],
                )
            ),
            Container(
              width: size.width/3,
              alignment: Alignment.center,
              child : (

              Text(
                  "\u{1F601}",
                  style: TextStyle(
                    fontSize: 60
                  )
              )//긍/부정 표현             @
            )
            ),
            Container(

                width: size.width/3,

                child: Column(
                  mainAxisAlignment:  MainAxisAlignment.center,
                  children: [
                    Text(
                        "\u{2B50}",
                        style: TextStyle(
                            fontSize: 40,
                        )
                    ),//관심 종목 표시         @

                  ],
                )
            ),
          ],
        )
    );
  }
  Widget stock_chart(Size size) {
    return Container(

        width: size.width,
        height: 180,
        child: Image.asset('images/stockchart.png', fit: BoxFit.fill)
         //stock_chart();
    );
  }//
  Widget stock_info(Size size) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      decoration: BoxDecoration(
        border : Border(
          top : BorderSide(width: 5, color: Color(0xFD0F0F36))
        )
      ),
        width: size.width/1.5,
        height: 100,

        child: Image.asset('images/stockinfo.png', fit: BoxFit.fill)
      //stock_chart();
    );
  }//
  Widget stock_news(Size size){
    return Container(

      height: 166,
      child :Column (
        children: [
          news(size),
          news(size),
        ],
      )
    );
  }
  Widget news(Size size){
    return Container(
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
        border: Border(
          bottom : BorderSide(width :1, color : Color(0xFD0F0F36))
        )
      ),
      width : size.width/1.5,
      child : Column(
        children: [
          Text('Name non-constant12312123123123 .', textAlign: TextAlign.left),
          Text('123213123213ui', textAlign: TextAlign.center,)
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home : Scaffold(

        body : Builder(
          builder : (BuildContext ctx) {
            Size size = MediaQuery.of(ctx).size;
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  stock(size),
                  stock_chart(size),
                  stock_info(size),
                  stock_news(size),
                ]
            );
          }
      )
      ),

      //column
        // 컨테이너로 통일
          //Row
            //컨테이너
              //Column
                //종목이름              @
                //종목 가격             @
                //전일 대비 등락ㄱ율     @
            //컨테이너
              //긍/부정 표현             @
            //컨테이너
              //Column
                //관심 종목 표시         @
                //공란
        // 종목 차트                    @
        // 종목 정보                    @
        // 종목 뉴스                    @

      //column
        //stock_top
        //stock_chart
        //stock_info
        //stock_news

    );
  }
}