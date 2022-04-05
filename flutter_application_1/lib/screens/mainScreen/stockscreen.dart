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
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';

class Stockscreen extends StatefulWidget {
  Stockscreen({Key? key}) : super(key: key);

  @override
  State<Stockscreen> createState() => _StockscreenState();
}

class _StockscreenState extends State<Stockscreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // animationController.dispose() instead of your controller.dispose
  }

  List<num>? dayVolume = [];
  List<num>? dayTime = [];
  List<num>? monthVolume = [];
  List<num>? monthTime = [];
  List<num>? yearVolume = [];
  List<num>? yearTime = [];
  List<num>? tenYearVolume = [];
  List<num>? tenYearTime = [];
  var dayMinimum;
  var monthMinimum;
  var yearMinimum;
  var tenYearMinimum;

  Future getDayData() async {
    var yfin = YahooFin();
    StockHistory hist = yfin.initStockHistory(ticker: "000660.KS");
    StockChart chart = await yfin.getChartQuotes(
        stockHistory: hist,
        interval: StockInterval.thirtyMinute,
        period: StockRange.oneDay);

    dayVolume = chart.chartQuotes!.close;
    dayTime = chart.chartQuotes!.timestamp;

    for (int i = 0; i < dayVolume!.length; i++) {
      if (dayTime!.isNotEmpty) {
        var date =
            DateTime.fromMillisecondsSinceEpoch(dayTime![i].toInt() * 1000);
        dayData.add(_ChartData(date, dayVolume![i].toDouble()));
      }
    }
    if (mounted) {
      setState(() {
        dayMinimum = dayVolume!.cast<num>().reduce(min);
      });
    }

    return "";
  }

  Future getMonthData() async {
    var yfin = YahooFin();
    StockHistory hist = yfin.initStockHistory(ticker: "000660.KS");
    StockChart chart = await yfin.getChartQuotes(
        stockHistory: hist,
        interval: StockInterval.oneDay,
        period: StockRange.oneMonth);

    monthVolume = chart.chartQuotes!.close;
    monthTime = chart.chartQuotes!.timestamp;
    for (int i = 0; i < monthVolume!.length; i++) {
      if (monthTime!.isNotEmpty) {
        var date =
            DateTime.fromMillisecondsSinceEpoch(monthTime![i].toInt() * 1000);
        monthData.add(_ChartData(date, monthVolume![i].toDouble()));
      }
    }
    monthMinimum = monthVolume!.cast<num>().reduce(min);

    return "";
  }

  Future getYearData() async {
    var yfin = YahooFin();
    StockHistory hist = yfin.initStockHistory(ticker: "000660.KS");
    StockChart chart = await yfin.getChartQuotes(
        stockHistory: hist,
        interval: StockInterval.oneMonth,
        period: StockRange.oneYear);

    yearVolume = chart.chartQuotes!.close;
    yearTime = chart.chartQuotes!.timestamp;
    for (int i = 0; i < yearVolume!.length; i++) {
      if (yearTime!.isNotEmpty) {
        var date =
            DateTime.fromMillisecondsSinceEpoch(yearTime![i].toInt() * 1000);
        yearData.add(_ChartData(date, yearVolume![i].toDouble()));
      }
    }
    yearMinimum = yearVolume!.cast<num>().reduce(min);

    return "";
  }

  Future getTenYearData() async {
    var yfin = YahooFin();
    StockHistory hist = yfin.initStockHistory(ticker: "000660.KS");
    StockChart chart = await yfin.getChartQuotes(
        stockHistory: hist,
        interval: StockInterval.oneMonth,
        period: StockRange.tenYear);

    tenYearVolume = chart.chartQuotes!.close;
    tenYearTime = chart.chartQuotes!.timestamp;

    for (int i = 0; i < tenYearVolume!.length; i++) {
      if (tenYearTime!.isNotEmpty) {
        var date =
            DateTime.fromMillisecondsSinceEpoch(tenYearTime![i].toInt() * 1000);
        tenYearData.add(_ChartData(date, tenYearVolume![i].toDouble()));
      }
    }
    tenYearMinimum = tenYearVolume!.cast<num>().reduce(min);

    return "";
  }

  chart() {
    getMonthData();
    getYearData();
    getTenYearData();
    getDayData();
  }
  // 종목 이름,가격,대비,긍/부정, 관심

  List<_ChartData> dayData = [];
  List<_ChartData> monthData = [];
  List<_ChartData> yearData = [];
  List<_ChartData> tenYearData = [];

  late TooltipBehavior _tooltip;
  late ZoomPanBehavior _zoompan;

  void ChartInit(List<_ChartData> data) async {
    data = [];

    // _tooltip = TooltipBehavior(enable: true);
  }

  Widget Stockmain(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: size.height * 0.02, horizontal: size.width * 0.05),
      // padding: EdgeInsets.all(size.width * 0.05),
      width: size.width * 0.9,
      // height: size.height * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stockinfo(size),
          tab(size),
          // ChartData(size),
        ],
      ),
    );
  }

  Widget tab(Size size) {
    return Center(
      child: SizedBox(
        width: size.width * 0.9,
        height: size.height * 0.375,
        child: ContainedTabBarView(
          tabs: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text("1D"),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text("1M"),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text("1Y"),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text("10Y"),
              ),
            ),
          ],
          initialIndex: 1,
          tabBarProperties: TabBarProperties(
            padding: EdgeInsets.all(8),
            indicatorPadding: EdgeInsets.only(
                left: size.width * 0.03, right: size.width * 0.03),
            unselectedLabelColor: Colors.grey[400],
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color(0xff0039A4)),
            margin: EdgeInsets.only(bottom: 8.0),
            position: TabBarPosition.bottom,
            background: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
          ),
          views: [
            DayChart(size, dayData),
            MonthChart(size, monthData),
            YearChart(size, yearData),
            TenYearChart(size, tenYearData),
          ],
          onChange: (index) {},
        ),
      ),
    );
  }

  Widget Chart(Size size, List<_ChartData> data, var minimum) {
    return Column(
      children: [
        Container(
          // margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          width: size.width * 0.9,
          height: size.height * 0.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            color: Colors.white,
          ),
          child: SizedBox(
            width: size.width * 0.9 * 0.9,
            height: size.height * 0.4,
            child: SfCartesianChart(
              primaryXAxis: DateTimeAxis(),
              primaryYAxis: NumericAxis(minimum: minimum),
              // tooltipBehavior: _tooltip,
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
      ],
    );
  }

  Widget DayChart(Size size, List<_ChartData> data) {
    return Chart(size, data, dayMinimum);
  }

  Widget MonthChart(Size size, List<_ChartData> data) {
    return Chart(size, data, monthMinimum);
  }

  Widget YearChart(Size size, List<_ChartData> data) {
    return Chart(size, data, yearMinimum);
  }

  Widget TenYearChart(Size size, List<_ChartData> data) {
    return Chart(size, data, tenYearMinimum);
  }

  Widget Stockinfo(Size size) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '삼성전자',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontFamily: 'Content',
                  fontSize: size.width * 0.06,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              SizedBox(width: size.width * 0.01),
              Text(
                "005930",
                style: TextStyle(
                    color: Colors.grey[700], fontSize: size.width * 0.04),
              )
            ],
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            '69,900',
            style: TextStyle(
              color: CHART_MINUS,
              fontFamily: 'Content',
              fontSize: size.width * 0.06,
              letterSpacing: 0,
              fontWeight: FontWeight.bold,
              height: 1,
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
                fontSize: size.width * 0.04,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

//종목 정보
  Widget newsInfo(Size size) {
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

  Widget devide(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: size.width * 0.05),
          width: size.height * 0.12,
          child: Divider(
            color: Colors.grey[400],
            thickness: 0.8,
          ),
        ),
        Text(
          "간편 로그인",
          style: TextStyle(color: Colors.grey[400]),
        ),
        Container(
          margin: EdgeInsets.only(left: size.width * 0.05),
          width: size.height * 0.12,
          child: Divider(
            color: Colors.grey[400],
            thickness: 0.8,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: chart(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (dayData.isNotEmpty) {
          return Scaffold(
            appBar: mainAppBar(context, "종목 정보"),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Stockmain(size),
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

class _ChartData {
  _ChartData(this.x, this.y);

  final DateTime x;
  final double y;
}
