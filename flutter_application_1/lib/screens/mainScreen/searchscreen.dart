// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

const SEARCH = Color.fromRGBO(0, 0, 0, 0.25);
void main() => runApp(Searchscreen());

class Searchscreen extends StatefulWidget {
  Searchscreen({Key? key}) : super(key: key);

  @override
  State<Searchscreen> createState() => _searchscreenState();
}

class _searchscreenState extends State<Searchscreen> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    return MaterialApp(
      title: "searchscreen",

      home: Scaffold(

          body: Builder(
              builder: (BuildContext ctx) {
                var mediaQuery = MediaQuery.of(ctx);

                return Container(
                  child: Column(
                    children: [
                      tempStatusbar(mediaQuery),
                      Navigationbar(mediaQuery),
                      SizedBox(height: mediaQuery.size.height*0.1),
                      Searchbar(mediaQuery)
                  ],
                )
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
              '검색',
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

Widget Searchbar(var mediaQuery){
  Size size = mediaQuery.size;

  return Container(
    width: size.width * 0.9,
    height : size.height * 0.04,
    margin: EdgeInsets.symmetric(horizontal: size.width*0.1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: SEARCH,
            offset: Offset(0,-2.5),
            blurRadius: 2,
            blurStyle: BlurStyle.inner
          )
        ],
        color: Color.fromRGBO(224, 228, 233, 1),
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: size.width*0.9* 0.02),
              child: SvgPicture.asset(
                  'assets/images/search.svg',
                  semanticsLabel: 'search'
              )
          ),
          Expanded(
            child: Container(
                child : Text(
                  '찾으시는 종목을 입력하세요', textAlign: TextAlign.left, style: TextStyle(
                    color: Color.fromRGBO(91, 99, 106, 1),
                    fontFamily: 'ABeeZee',
                    fontSize: 14,
                    letterSpacing: 0,
                    fontWeight: FontWeight.normal,
                    height: 1
                ),)
            ),
          )
        ],
      )
  );
}