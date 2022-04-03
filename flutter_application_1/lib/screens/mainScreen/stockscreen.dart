// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/stock_list.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_1/Color/Color.dart';
import 'package:flutter_application_1/Components/main_app_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:yahoofin/yahoofin.dart';
import 'dart:math';

//Firebase 적용 사항
List<String> stockIcon = <String>['price', 'perc', 'eps', 'marketcap', 'dividend'];
List<String> stockInfodetail = <String>['주가', '주가수익률', '주당순이익', '시가총액', '배당'];
List<String> stockValue = <String>['99,900원(+2.49%)', '45.79%', '32.54', '240.73', '1.50%(FY:2077'];
List<String> mediaName = <String>['건민일보','어쩔티비','123'];
List<String> newsTitle = <String>['저녁 만찬으로 비비큐먹어...충격', '코로나 언제 끝나냐', '123'];

class Stockscreen extends StatefulWidget {
  Stockscreen({Key? key}) : super(key: key);

  @override
  State<Stockscreen> createState() => _StockscreenState();
}

class _StockscreenState extends State<Stockscreen> {
  List<num>? volume = [];
  List<num>? time = [];
  var volume_max;
  var volume_min;
  var maximum;
  var minimum;
  getData() async {
    var yfin = YahooFin();
    StockHistory hist = yfin.initStockHistory(ticker: "^KS11");
    StockChart chart = await yfin.getChartQuotes(
        stockHistory: hist,
        interval: StockInterval.oneDay,
        period: StockRange.oneMonth);
    volume = chart.chartQuotes!.close;
    time = chart.chartQuotes!.timestamp;
    volume_max = volume!.cast<num>().reduce(max);
    minimum = volume!.cast<num>().reduce(min) - 10;
    maximum = volume_max + volume_max / 10;
    initState();
  }

  // 종목 이름,가격,대비,긍/부정, 관심
  Widget Stockmain(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: size.height * 0.02, horizontal: size.width * 0.05),
      width: size.width * 0.9,
      height: size.height * 0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
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
                              fontSize: size.width * 0.09,

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
                              fontSize: size.width * 0.055,
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
                              fontSize: size.width * 0.035,
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
            // Firebase 적용 사항
            Expanded(
                child : SvgPicture.asset(
                    'assets/icons/nice.svg',
                    semanticsLabel: 'nice'
                )
              ],
            ),
          ),
          // 긍/부정
          Expanded(
            child: SvgPicture.asset('assets/icons/nice.svg',
                semanticsLabel: 'nice'),
          ),
            //관심
            // Firebase 적용 사항
            Stack(
              children: [
                Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                        margin: EdgeInsets.only(top: size.height*0.2 * 0.1, right:size.width* 0.9*0.05),
                        height : size.height*0.2 * 0.3,
                        width : size.height* 0.2 * 0.3,

  List<_ChartData> data = [];
  late TooltipBehavior _tooltip;
  late ZoomPanBehavior _zoompan;

  void initState() {
    print(volume);
    print(time);
    data = [];
    for (int i = 0; i < volume!.length; i++) {
      if (time!.isNotEmpty) {
        var date = DateTime.fromMillisecondsSinceEpoch(time![i].toInt() * 1000);
        data.add(_ChartData(date, volume![i].toDouble()));
      }
    }
    print(data);
    _tooltip = TooltipBehavior(enable: true);
    _zoompan = ZoomPanBehavior(
      enableDoubleTapZooming: true,
      enableMouseWheelZooming: true,
    );
    // super.initState();
  }

// 종목 차트
  // Firebase 적용 사항
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
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: size.width * 0.05, vertical: size.height * 0.01),
          width: size.width * 0.9,
          height: size.height * 0.05,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  offset: Offset(0, 4),
                  blurRadius: 1)
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: size.height * 0.05,
                height: size.height * 0.05,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  color: CHART_MINUS,
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
                              fontSize: size.width * 0.045,
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
                              fontSize: size.width * 0.045,
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
                              fontSize: size.width * 0.045,
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
                              fontSize: size.width * 0.045,
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
                              fontSize: size.width * 0.045,
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
      ],
    );
  }

//종목 정보
// Firebase 적용 사항
  Widget Stockinfolist(Size size){

    return Container(
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
        width : size.width*0.9,
        child :ExpansionTile(
          initiallyExpanded : false,
          title: Text('종목 정보'
          ),
            children : [ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
             physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.03, ),
              itemCount: stockIcon.length,
              itemBuilder: (BuildContext context, int index) {
                return Stockinfo(size, stockIcon[index], stockInfodetail[index], stockValue[index]);
              },
            )]

    ),
    );
  }
  Widget Stockinfo(Size size, String Icon, String Infodetail, String Value) {
    return Container(
      margin : EdgeInsets.only(bottom: size.height * 0.06),
      child : Row(
        children: [
          Container(

            width: size.width * 0.04,
            height: size.width * 0.04 ,
            child : (SvgPicture.asset('assets/icons/stock${Icon}.svg',
            semanticsLabel: '${stockIcon}',
            color : CHART_MINUS))

          ),
          SizedBox(width : size.width * 0.02),
          Text(
            '${Infodetail}', textAlign: TextAlign.left, style: TextStyle(
              color: Color.fromRGBO(91, 99, 106, 1),
              fontFamily: 'ABeeZee',
              fontSize: size.width * 0.04,
              letterSpacing: 0,
              fontWeight: FontWeight.bold,
              height: 1
          ),
          ),
          Expanded(
            child : Text(
              '${Value}',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color.fromRGBO(91, 99, 106, 1),

                fontFamily: 'ABeeZee',
                fontSize: size.width * 0.036,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
                height: 1
            ),
            )
          )

        ],
      )
    );
  }

//종목 뉴스
  Widget Stocknewslist(Size size){

    return Container(
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
      width : size.width*0.9,
      child :ExpansionTile(
          initiallyExpanded : false,
          title: Text('종목 뉴스'
          ),
          children : [
            ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04 ),
              itemCount: mediaName.length,
              itemBuilder: (BuildContext context, int index) {
                return Stocknews(size, mediaName[index], newsTitle[index]);
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(color: GREY),
          )
          ]

      ),
    );
  }
  Widget Stocknews(Size size, String Name, String Title){
    return Container(

      child : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children : [
          Text(
            Name,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontFamily: 'Content',
              fontSize: size.width * 0.04,
              letterSpacing: 0,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
          SizedBox(height: size.height*0.01),
          Text(
            Title,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 0.8),
              fontFamily: 'Content',
              fontSize: size.width * 0.036,
              letterSpacing: 0,
              fontWeight: FontWeight.normal,
              height: 1,
            ),
          ),

        ]
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: mainAppBar(context, "종목 정보"),
      body: FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Column(
            children: [
              SizedBox(
                height: size.height * 0.01,
              ),
              Stockmain(size),
              Stockchart(size),
              Stockinfo(size),
            ],
          );
        },
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final DateTime x;
  final double y;
}
