// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


//view용 임시 리스트
final List<String> Name = <String>['삼성전자', '이승중견기업', '동국산업', 'LG에너지솔루션', '빵꾸똥꾸' ];
final List<int> Price = <int>[79900, 999999900, 12350, 379900, 12321];
final List<String> Perc = <String>['-2.49%', '+1.49%', '+3.49%', '-5.12%', '+30%'];
final List<int> Volume = <int>[265232,52802,1232,25232, 1557];

const MINUS = Color.fromRGBO(0, 57, 164, 0.9);
const PLUS = Color.fromRGBO(238, 71, 81, 0.9);

void main() => runApp(Recentscreen());

class Recentscreen extends StatefulWidget {
  Recentscreen({Key? key}) : super(key: key);

  @override
  State<Recentscreen> createState() => _recentscreenState();
}

class _recentscreenState extends State<Recentscreen> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    return MaterialApp(
      title : "recentscreen",

      home : Scaffold(

          body : Builder(
              builder : (BuildContext ctx) {
                var mediaQuery = MediaQuery.of(ctx);

                return       // Figma Flutter Generator NavigationWidget - FRAME - HORIZONTAL
                  Column(
                      children : [
                        tempStatusbar(mediaQuery),
                        Navigationbar(mediaQuery),
                        SizedBox(height: mediaQuery.size.height * 0.035),
                        CardList(mediaQuery),


                      ]
                  );
              }
          )
      ),


    );
  }
}

// Flutter 기본 statusbar만큼의 공간 나중에 삭제
Widget tempStatusbar(var mediaQuery){
  return Container(padding: EdgeInsets.only(top: mediaQuery.padding.top));
}

// navigator 홈화면은 vectorstroke 생략
Widget Navigationbar(var mediaQuery){
  Size size = mediaQuery.size;
  return Container(
      decoration: BoxDecoration(

        color : Color.fromRGBO(255, 255, 255, 1),
      ),

      padding: EdgeInsets.symmetric(horizontal: size.width*0.016, vertical: size.height*0.008),

      child : Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              width : size.width * 0.25,
              height : size.height * 0.04,
              child: Container(
                  padding: EdgeInsets.only(left: size.width * 0.25 * 0.1),
                  alignment: Alignment.centerLeft,
                  child : SvgPicture.asset(
                      'assets/images/vectorstroketoleft.svg',
                      semanticsLabel: 'vectorstroketoleft'
                  )
              )
          ),
          SizedBox(width : size.width * 0.25 * 0.1),
          Text(
              '최근 조회 목록',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1),
                fontFamily: 'Content',
                fontSize: 18,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
                height:1,
              )
          ),
          SizedBox(width : size.width * 0.25 * 0.1),
          Container(
              width : size.width * 0.25,
              height : size.height * 0.04,
              padding: EdgeInsets.only(right: size.width * 0.25 * 0.1),
              decoration: BoxDecoration(
                border : Border.all(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  width: 1,
                ),
              ),
              child : Stack(
                children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: SvgPicture.asset(
                          'assets/images/vectorset.svg',
                          semanticsLabel: 'vectorset'
                      )
                  )],
              )
          ),
        ],
      )
  );
}

//종목을 카드로 나타냄
Widget Stockcard(var mediaQuery, var name, var price, var perc, var volume){
  var color;
  if(perc[0] == '+'){
    color = PLUS;
  }else{
    color = MINUS;
  }
  var intl = NumberFormat.currency(locale: "ko_KR", symbol: "￦");

  price = intl.format(price);
  volume = intl.format(volume);

  Size size = mediaQuery.size;
  return Container(
      height: size.height * 0.17,
      width: size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius : BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        color : Color.fromRGBO(255, 255, 255, 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: size.width*0.03, vertical: size.height*0.01),
      margin: EdgeInsets.only(bottom:size.height*0.03),
      child : Column(
        children: [
          Container(
              padding: EdgeInsets.only(top : size.height*0.01),

              child : Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                      margin: EdgeInsets.only(right: size.width*0.03),
                      child : SvgPicture.asset(
                          'assets/images/vectorcheckbox.svg',
                          semanticsLabel: 'vectorcheckbox'
                      )
                  ),
                  Expanded(
                      child: Text(
                          name,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontFamily: 'Content',
                            fontSize: 18,
                            letterSpacing: 0,
                            fontWeight: FontWeight.normal,
                            height:1,
                          )
                      )
                  ),
                  Container(
                      child : SvgPicture.asset(
                          'assets/images/vectorcross.svg',
                          semanticsLabel: 'vectorcross'
                      )
                  ),
                ],
              )
          ),
          Container(
            // decoration: BoxDecoration(
            //   border: Border.all(width:1 , color: Colors.black),
            //   color : Color.fromRGBO(255, 255, 255, 1),
            // ),
              child : Column(
                children: [
                  Container(
                      padding: EdgeInsets.only(left :  size.width*0.01, top : size.height*0.02),

                      child : Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius : BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                                bottomLeft: Radius.circular(4),
                                bottomRight: Radius.circular(4),
                              ),
                              color : Color.fromRGBO(249, 249, 249, 1),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: size.width*0.03, vertical: size.height*0.01),
                            child : Text(
                                '주가 : $price',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: color,
                                  fontFamily: 'Content',
                                  fontSize: 12,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                  height:1,
                                )
                            ),
                          ),
                          SizedBox(width: size.width*0.03),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius : BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                                bottomLeft: Radius.circular(4),
                                bottomRight: Radius.circular(4),
                              ),
                              color : Color.fromRGBO(249, 249, 249, 1),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: size.width*0.03, vertical: size.height*0.01),
                            child : Text(
                                '대비(등락) : $perc',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: color,
                                  fontFamily: 'Content',
                                  fontSize: 12,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                  height:1,
                                )
                            ),
                          ),
                        ],
                      )
                  ),
                  SizedBox(height: size.height*0.01),
                  Container(
                      padding: EdgeInsets.only(left :  size.width*0.01),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius : BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                                bottomLeft: Radius.circular(4),
                                bottomRight: Radius.circular(4),
                              ),
                              color : Color.fromRGBO(249, 249, 249, 1),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: size.width*0.03, vertical: size.height*0.01),
                            child : Text(

                                '거래량 : $volume',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: color,
                                  fontFamily: 'Content',
                                  fontSize: 12,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                  height:1,
                                )
                            ),
                          ),
                          Expanded(
                              child : SizedBox()
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: size.width*0.03, vertical : size.height*0.005),
                              decoration: BoxDecoration(
                                borderRadius : BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),

                                ),
                                color: Color.fromRGBO(249, 249, 249, 1),
                                boxShadow : [
                                  BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.25),
                                      offset: Offset(0,4),
                                      blurRadius: 4
                                  )],
                                border : Border.all(
                                  color: Color.fromRGBO(25, 25, 25, 1),
                                  width: 1,
                                ),
                              ),
                              child : Row(
                                children: [
                                  Container(

                                      child : Text(
                                        '자세히',
                                        style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontFamily: 'ABeeZee',
                                            fontSize: 14,

                                            fontWeight: FontWeight.normal,
                                            height: 1.2
                                        ),

                                      )
                                  ),
                                  SizedBox(width:size.width*0.03),
                                  Container(

                                      child: SvgPicture.asset(
                                          'assets/images/vectorstroketoright.svg',
                                          semanticsLabel: 'vectorstroketoright'
                                      )
                                  )
                                ],
                              )
                          ),
                        ],
                      )
                  ),
                ],
              )
          )
        ],
      )


  );
}


// 종목카드를 모은 리스트
Widget CardList(var mediaQuery){
  Size size = mediaQuery.size;
  return Expanded(
      child : ListView.builder(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.symmetric(horizontal: size.width*0.05 ),
          itemCount : Name.length,
          itemBuilder: (BuildContext context, int index){
            return Stockcard(mediaQuery, '${Name[index]}', Price[index],'${Perc[index]}',Volume[index]);
          }
      )
  );
}