// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_1/Color/Color.dart';
import 'package:flutter_application_1/Components/main_app_bar.dart';

void main() => runApp(Stockscreen());

class Stockscreen extends StatefulWidget {
  Stockscreen({Key? key}) : super(key: key);

  @override
  State<Stockscreen> createState() => _StockscreenState();
}



class _StockscreenState extends State<Stockscreen> {
  // 종목 이름,가격,대비,긍/부정, 관심
  Widget Stockmain(Size size){

    return Container(
        margin: EdgeInsets.symmetric(vertical: size.height*0.02 ,horizontal: size.width*0.05 ),
        width: size.width*0.9,
        height: size.height * 0.2,
        decoration: BoxDecoration(
          borderRadius : BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
          color : Colors.white,
          boxShadow : [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                offset: Offset(0,4),
                blurRadius: 2
            )],
        ),
        child : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 이름,가격,대비
            Container(
                margin: EdgeInsets.only(left: size.width*0.05),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(

                        child : Text(
                            '삼성전자',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Content',
                              fontSize: 36,

                              fontWeight: FontWeight.bold,
                              height:1,
                            )
                        )
                    ),
                    Container(
                        margin: EdgeInsets.only(top: size.height*0.01),
                        child : Text(
                            '69,900',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: CHART_MINUS,
                              fontFamily: 'Content',
                              fontSize: 22,
                              letterSpacing: 0,
                              fontWeight: FontWeight.normal,
                              height:1,
                            )
                        )
                    ),
                    Container(
                        margin: EdgeInsets.only(top:size.height*0.005),

                        child : Text(
                            '-203(-2.49%)',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: CHART_MINUS,
                              fontFamily: 'Content',
                              fontSize: 14,
                              letterSpacing: 0,
                              fontWeight: FontWeight.normal,
                              height:1,
                            )
                        )
                    )
                  ],
                )
            ),
            // 긍/부정
            Expanded(
                child : SvgPicture.asset(
                    'assets/icons/nice.svg',
                    semanticsLabel: 'nice'
                )
            ),

            //관심
            Stack(
              children: [
                Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                        margin: EdgeInsets.only(top: size.height*0.2 * 0.1, right:size.width* 0.9*0.05),
                        height : size.height*0.2 * 0.3,
                        width : size.height* 0.2 * 0.3,

                        child : SvgPicture.asset(
                            'assets/icons/countingstar.svg',
                            semanticsLabel: 'countingstar'
                        )
                    )
                )
              ],
            )
          ],
        )
    );
  }

// 종목 차트
  Widget Stockchart(Size size){

    return Container(
        child : Column(
          children: [
            Container(
                margin: EdgeInsets.symmetric(horizontal: size.width*0.05 ),
                width: size.width*0.9,
                height: size.height * 0.25,
                decoration: BoxDecoration(
                  borderRadius : BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  color : Colors.white,
                  boxShadow : [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.25),
                        offset: Offset(0,4),
                        blurRadius: 2
                    )],
                ),
                child : Container(
                    width: size.width*0.9*0.9,
                    height: size.height*0.25*0.9,
                    child :Image.asset('assets/charts/chart.png', fit: BoxFit.fill,)
                )
            ),

            Container(
                margin: EdgeInsets.symmetric(horizontal: size.width*0.05, vertical: size.height*0.01 ),
                width: size.width*0.9,
                height: size.height * 0.05,
                decoration: BoxDecoration(
                  borderRadius : BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  color : Colors.white,
                  boxShadow : [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.25),
                        offset: Offset(0,4),
                        blurRadius: 1
                    )],
                ),
                child : Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        width: size.height*0.05,
                        height: size.height*0.05,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius : BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          color: CHART_MINUS,
                        ),

                        child : Text(
                            '1D',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Content',
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              height:1,
                            )
                        )
                    ),
                    Container(
                        width: size.height*0.05,
                        height: size.height*0.05,
                        alignment: Alignment.center,
                        child : Text(
                            '1W',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromRGBO(158, 158, 158, 1),
                              fontFamily: 'Content',
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              height:1,
                            )
                        )
                    ),
                    Container(
                        width: size.height*0.05,
                        height: size.height*0.05,
                        alignment: Alignment.center,
                        child : Text(
                            '1M',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromRGBO(158, 158, 158, 1),
                              fontFamily: 'Content',
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              height:1,
                            )
                        )
                    ),
                    Container(
                        width: size.height*0.05,
                        height: size.height*0.05,
                        alignment: Alignment.center,
                        child : Text(
                            '1Y',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromRGBO(158, 158, 158, 1),
                              fontFamily: 'Content',
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              height:1,
                            )
                        )
                    ),
                    Container(
                        width: size.height*0.05,
                        height: size.height*0.05,
                        alignment: Alignment.center,
                        child : Text(
                            'All',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromRGBO(158, 158, 158, 1),
                              fontFamily: 'Content',
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              height:1,
                            )
                        )
                    ),
                  ],
                )
            )
          ],
        )
    );
  }

//종목 정보
  Widget Stockinfo(Size size){

    return Container(
        width : size.width*0.9,
        height: size.height*0.08,
        color: Colors.white,
        child :ExpansionTile(

          title: Text(
            '종목정보',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontFamily: 'Content',
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.normal,
              height:1,
            ),

          ),
          initiallyExpanded : false,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius : BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                border: Border.all(width:3, color: Colors.black),
                color : Color.fromRGBO(142, 142, 142, 1),
                boxShadow : [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      offset: Offset(0,4),
                      blurRadius: 2
                  )],
              ),

              child: Column(
                children: [
                  Container(
                      child : Text('123'))
                ],
              ),
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: mainAppBar(context, "종목 정보"),
      body: Column(
        children: [
        SizedBox(height: size.height*0.01,),
        Stockmain(size),
        Stockchart(size),
        Stockinfo(size),
        ],
      ),
    );
  }
}


