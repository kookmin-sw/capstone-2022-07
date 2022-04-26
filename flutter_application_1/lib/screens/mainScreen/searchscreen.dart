// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/setting_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_1/Components/main_app_bar.dart';
import 'package:flutter_application_1/Color/color.dart';

class Searchscreen extends StatefulWidget {
  Searchscreen({Key? key}) : super(key: key);
  @override
  State<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: mainAppBar(
        context,
        "검색",
        SettingButton(context),
      ),
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.1,
          ),
          Searchbar(size),
        ],
      ),
    );
  }
}

Widget Searchbar(Size size) {
  return Container(
    width: size.width * 0.9,
    height: size.height * 0.04,
    margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      ),
    ),
      child: Row(
        children: [
          Container(
              margin: EdgeInsets.only(left: size.width * 0.9 * 0.02),
              child: SvgPicture.asset('assets/icons/search.svg',
                  semanticsLabel: 'search')),
          
          // Firebase 적용 사항
          // 입력 시 입력한 string이 포함되는 종목이 노출되도록해야함 
          Expanded(
            child: Text(
              '찾으시는 종목을 입력하세요',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Color.fromRGBO(91, 99, 106, 1),
                  fontFamily: 'ABeeZee',
                  fontSize: size.width * 0.035,
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                  height: 1),
            ),
          )
        ]
      )

  );
}
