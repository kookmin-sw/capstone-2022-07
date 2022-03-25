// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

void main() => runApp(Mainscreen());

class Mainscreen extends StatefulWidget {
  Mainscreen({Key? key}) : super(key: key);

  @override
  State<Mainscreen> createState() => _mainscreenState();
}

class _mainscreenState extends State<Mainscreen> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    return MaterialApp(
      title : "mainscreen",

      home : Scaffold(

          body : Builder(
              builder : (BuildContext ctx) {
                var mediaQuery = MediaQuery.of(ctx);

                return       // Figma Flutter Generator NavigationWidget - FRAME - HORIZONTAL
                  Column(
                    children : [
                      tempStatusbar(mediaQuery),
                      Navigationbar(mediaQuery),
                      SizedBox(height: mediaQuery.size.height * 0.055),
                      Stockindex(mediaQuery),
                      SizedBox(height: mediaQuery.size.height * 0.055),
                      Idontknow(mediaQuery),
                      //nav_Bar
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
            // child : SvgPicture.asset(
            //     'assets/images/vectorstroke.svg',
            //     semanticsLabel: 'vectorstroke'
            // )
          )
        ),
        SizedBox(width : size.width * 0.25 * 0.1),
        Text(
            '홈',
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

// 주요지수를 알려주는 위젯
Widget Stockindex(var mediaQuery){
  Size size = mediaQuery.size;
  return Container(
      width: size.width * 0.9,
      height: size.height * 0.4,
      decoration: BoxDecoration(
        borderRadius : BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        boxShadow : [BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            offset: Offset(0,4),
            blurRadius: 4
        )],
        color : Color.fromRGBO(255, 255, 255, 1),
      ),
      child : Column (
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
              padding: EdgeInsets.only(left: size.width * 0.25 * 0.1),
            alignment: Alignment.centerLeft,

              width: size.width * 0.9,
              height: size.height * 0.4 * 0.13,
            child : Text('주요지수', textAlign: TextAlign.left, style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1),
                fontFamily: 'ABeeZee',
                fontSize: 17,
                fontWeight: FontWeight.normal,
                height: 1
            ),)
          ),
          Container(

              width: size.width * 0.9,
              height: size.height * 0.4 * 0.15,

            child : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(

                  child : Text('코스피 종합', textAlign: TextAlign.left, style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontFamily: 'ABeeZee',
                      fontSize: 17,
                      fontWeight: FontWeight.normal,
                      height: 1
                  ),)
                ),
                Container(
                    child : Text('코스닥 종합', textAlign: TextAlign.left, style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'ABeeZee',
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                        height: 1
                    ),)
                ),
              ],
            )


          ),

          Container(

              width: size.width * 0.9,
              height: size.height * 0.4 * 0.15,

              child : Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                      width: size.width * 0.9 * 0.5,

                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 0),
                      child : Column(
                        children: [
                          Container(
                              height: size.height * 0.4 * 0.15 * 0.5,
                            child : Text('2,686.3', textAlign: TextAlign.center, style: TextStyle(
                                color : Color.fromRGBO(0, 57, 164, 0.9),
                                fontFamily: 'ABeeZee',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                height: 1
                            ),
                            )
                          ),
                          Expanded(
                              child : Text('-3.72', textAlign: TextAlign.center, style: TextStyle(
                                  color : Color.fromRGBO(0, 57, 164, 0.9),
                                  fontFamily: 'ABeeZee',
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  height: 1
                              ),
                              )
                          )
                        ],
                      )
                  ),
                  Container(
                      width: size.width * 0.9 * 0.5,

                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 0),
                      child : Column(
                        children: [
                          Container(
                              height: size.height * 0.4 * 0.15 * 0.5,
                              child : Text('918.4', textAlign: TextAlign.center, style: TextStyle(
                                  color : Color.fromRGBO(239, 54, 65, 0.8999999761581421),
                                  fontFamily: 'ABeeZee',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  height: 1
                              ),
                              )
                          ),
                          Expanded(
                              child : Text('+4.36', textAlign: TextAlign.center, style: TextStyle(
                                  color : Color.fromRGBO(239, 54, 65, 0.8999999761581421),
                                  fontFamily: 'ABeeZee',
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  height: 1
                              ),
                              )
                          )
                        ],
                      )
                  ),
                ],
              )


          ),
          Expanded(
            child :  Container(

              child : Row(
                children: [
                  Container(
                    child :
                    Image.asset('assets/images/chart.png',width: size.width * 0.9 * 0.5, height: size.height * 0.4 * 0.4, fit: BoxFit.fitHeight)
                  ),
                  Container(
                      child :
                      Image.asset('assets/images/chart2.png',width: size.width * 0.9 * 0.5, height: size.height * 0.4 * 0.4, fit: BoxFit.fitHeight)
                  )
                ],
              )
          )
          ),
      ],
    )
  );
}


//뭐넣을지 미정
Widget Idontknow(var mediaQuery){
  Size size = mediaQuery.size;
  return Container(
    width: size.width * 0.9,
    height : size.height * 0.3,
    decoration: BoxDecoration(
      borderRadius : BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
        bottomLeft: Radius.circular(8),
        bottomRight: Radius.circular(8),
      ),
      boxShadow : [BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.25),
          offset: Offset(0,4),
          blurRadius: 4
      )],
      color : Color.fromRGBO(255, 255, 255, 1),
    ),
  );
}