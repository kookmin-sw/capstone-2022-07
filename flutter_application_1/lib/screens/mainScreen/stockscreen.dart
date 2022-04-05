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
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              offset: Offset(0, 4),
              blurRadius: 2)
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 이름,가격,대비
          Container(
            margin: EdgeInsets.only(left: size.width * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '삼성전자',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Content',
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.01),
                  child: Text(
                    '69,900',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: CHART_MINUS,
                      fontFamily: 'Content',
                      fontSize: 22,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.005),
                  child: Text(
                    '-203(-2.49%)',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: CHART_MINUS,
                      fontFamily: 'Content',
                      fontSize: 14,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1,
                    ),
                  ),
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
          Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(
                      top: size.height * 0.2 * 0.1,
                      right: size.width * 0.9 * 0.05),
                  height: size.height * 0.2 * 0.3,
                  width: size.height * 0.2 * 0.3,
                  child: SvgPicture.asset('assets/icons/countingstar.svg',
                      semanticsLabel: 'countingstar'),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

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
  Widget Stockchart(Size size) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          width: size.width * 0.9,
          height: size.height * 0.4,
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
                  blurRadius: 2)
            ],
          ),
          child: SizedBox(
            width: size.width * 0.9 * 0.9,
            height: size.height * 0.4,
            child: SfCartesianChart(
              primaryXAxis: DateTimeAxis(),
              primaryYAxis: NumericAxis(minimum: volume_min, interval: 10),
              tooltipBehavior: _tooltip,
              // zoomPanBehavior: _zoompan,
              series: <ChartSeries<_ChartData, DateTime>>[
                AreaSeries<_ChartData, DateTime>(
                  dataSource: data,
                  xValueMapper: (_ChartData data, _) => data.x,
                  yValueMapper: (_ChartData data, _) => data.y,
                  name: 'Gold',
                  color: Color(0xff0039A4),
                  gradient: LinearGradient(colors: [
                    Color(0xff0039A4).withOpacity(0.5),
                    Color(0xff0039A4),
                  ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
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
                child: TextButton(
                  child: Text('1D'),
                  onPressed: () {
                    getData();
                  },
                ),
              ),
              Container(
                width: size.height * 0.05,
                height: size.height * 0.05,
                alignment: Alignment.center,
                child: Text(
                  '1W',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(158, 158, 158, 1),
                    fontFamily: 'Content',
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    height: 1,
                  ),
                ),
              ),
              Container(
                width: size.height * 0.05,
                height: size.height * 0.05,
                alignment: Alignment.center,
                child: Text(
                  '1M',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(158, 158, 158, 1),
                    fontFamily: 'Content',
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    height: 1,
                  ),
                ),
              ),
              Container(
                width: size.height * 0.05,
                height: size.height * 0.05,
                alignment: Alignment.center,
                child: Text(
                  '1Y',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(158, 158, 158, 1),
                    fontFamily: 'Content',
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    height: 1,
                  ),
                ),
              ),
              Container(
                width: size.height * 0.05,
                height: size.height * 0.05,
                alignment: Alignment.center,
                child: Text(
                  'All',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(158, 158, 158, 1),
                    fontFamily: 'Content',
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

//종목 정보
  Widget Stockinfo(Size size) {
    return Container(
      width: size.width * 0.9,
      height: size.height * 0.08,
      color: Colors.white,
      child: ExpansionTile(
        title: Text(
          '종목정보',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1),
            fontFamily: 'Content',
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.normal,
            height: 1,
          ),
        ),
        initiallyExpanded: false,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              border: Border.all(width: 3, color: Colors.black),
              color: Color.fromRGBO(142, 142, 142, 1),
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                    offset: Offset(0, 4),
                    blurRadius: 2)
              ],
            ),
            child: Column(
              children: [Text('123')],
            ),
          )
        ],
      ),
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
