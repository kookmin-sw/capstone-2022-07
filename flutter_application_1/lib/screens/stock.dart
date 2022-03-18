// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

void main() => runApp(stock());

class stock extends StatefulWidget {
  stock({Key? key}) : super(key: key);

  @override
  State<stock> createState() => _stockState();
}

class _stockState extends State<stock> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home : Scaffold(
        body : Column(
          children : [
            Container(
              child : Row(
                children: [
                  Container(
                    child: Column(
                      children: [
                        //종목이름              @
                        //종목 가격             @
                        //전일 대비 등락ㄱ율     @
                      ],
                    )
                  ),
                  Container(
                    //긍/부정 표현             @
                  ),
                  Container(
                    child : Column(
                      children: [
                        //관심 종목 표시         @
                        //공란
                      ],
                    )
                  ),
                ],
              )
            ),
            Container(
              //stock_chart();
            ),
            Container(
              //stock_info
            ),
            Container(
              //stock_news
            )
          ]
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

    );
  }
}