// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/Components/star_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_1/Color/color.dart';
import 'package:flutter_application_1/Components/main_app_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:yahoofin/yahoofin.dart';
import 'dart:math';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';

class Stockscreen extends StatefulWidget {
  Stockscreen({
    Key? key,
    required this.stockName,
  }) : super(key: key);

  final String stockName;

  @override
  State<Stockscreen> createState() => _StockscreenState();
}

class _StockscreenState extends State<Stockscreen> {
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, format: 'point.size');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // animationController.dispose() instead of your controller.dispose
  }

  late Color stockColor;

  List<_ChartData> dayData = [];
  List<_ChartData> monthData = [];
  List<_ChartData> yearData = [];
  List<_ChartData> tenYearData = [];

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

  Map<String, dynamic> firebaseStockData = {};
  List<Map<String, dynamic>> newsDataList = [];

  Future getStockInfo() async {
    CollectionReference stocks = FirebaseFirestore.instance.collection('stock');
    QuerySnapshot stockData =
        await stocks.where('name', isEqualTo: widget.stockName).get();

    CollectionReference news =
        stocks.doc(stockData.docs[0].id).collection("news");

    Future<void> _getNewsList(List<Map<String, dynamic>> list) async {
      await news.get().then(
        (QuerySnapshot qs) {
          for (var doc in qs.docs) {
            Map<String, dynamic> topnews = doc.data() as Map<String, dynamic>;
            list.add(topnews);
          }
        },
      );
    }

    _getNewsList(newsDataList);

    if (stockData.size == 0) {
      return null;
    } else {
      return stockData.docs[0].data();
    }
  }

  //Firebase 적용사항
  List<String> stockIcon = <String>[
    'price',
    'perc',
    'eps',
    'marketcap',
    'dividend'
  ];
  List<String> stockInfodetail = <String>['주가', '주가수익률', '주당순이익', '시가총액', '배당'];

  //Firebase 적용사항
  List<String> stockValue = <String>['', '', '', '', ''];
  Future getDayData(String ticker) async {
    var yfin = YahooFin();
    StockHistory hist = yfin.initStockHistory(ticker: ticker);
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

    return "";
  }

  Future getMonthData(String ticker) async {
    var yfin = YahooFin();
    StockHistory hist = yfin.initStockHistory(ticker: ticker);
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

  Future getYearData(String ticker) async {
    var yfin = YahooFin();
    StockHistory hist = yfin.initStockHistory(ticker: ticker);
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

  Future getTenYearData(String ticker) async {
    var yfin = YahooFin();
    StockHistory hist = yfin.initStockHistory(ticker: ticker);
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

  chartInit(String ticker) async {
    await getMonthData(ticker);
    await getYearData(ticker);
    await getTenYearData(ticker);
    await getDayData(ticker);
  }

  // 종목 이름,가격,대비,긍/부정, 관심

  Widget TabContainer(String text) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(text),
      ),
    );
  }

  Widget InfoTabContainer(Size size, String text) {
    return Container(
      margin:
          EdgeInsets.only(left: size.width * 0.03, right: size.width * 0.03),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        // border: Border.all(color: (Colors.grey[400])!, width: ),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(text),
      ),
    );
  }

  Widget Stockmain(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: size.height * 0.02, horizontal: size.width * 0.05),
      padding: EdgeInsets.all(size.width * 0.01),
      width: size.width * 0.9,
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
          Stockinfo(size, firebaseStockData["name"], firebaseStockData["code"],
              firebaseStockData["price"], firebaseStockData["perc"]),
          chartTab(size),
        ],
      ),
    );
  }

  Widget chartTab(Size size) {
    return Center(
      child: SizedBox(
        width: size.width * 0.9,
        height: size.height * 0.39,
        child: ContainedTabBarView(
          tabs: [
            TabContainer("1D"),
            TabContainer("1M"),
            TabContainer("1Y"),
            TabContainer("10Y"),
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
        ),
      ),
    );
  }

  Widget infoTab(Size size) {
    return Center(
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.6,
        margin: EdgeInsets.only(bottom: size.height * 0.05),
        child: ContainedTabBarView(
          tabs: [
            InfoTabContainer(size, "종목 뉴스"),
            InfoTabContainer(size, "종목 정보"),
          ],
          initialIndex: 0,
          tabBarProperties: TabBarProperties(
            padding: EdgeInsets.all(8),
            indicatorPadding: EdgeInsets.only(
                left: size.width * 0.03, right: size.width * 0.03),
            labelStyle: TextStyle(color: Color(0xff0039A4)),
            labelColor: Color(0xff0039A4),
            unselectedLabelColor: Colors.grey[400],
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                // border: Border.all(color: (Colors.grey[400])!),
                border: Border.all(color: Color(0xff0039A4), width: 1),
                color: Color(0xffEFF1F6)),
            margin: EdgeInsets.only(bottom: 8.0),
            background: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
            ),
          ),
          views: [
            stockNewsTab(size, '종목 뉴스'),
            stockInfoTab(size, '종목 정보'),
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
              plotAreaBorderColor: Colors.transparent,
              primaryXAxis: DateTimeAxis(isVisible: false),
              primaryYAxis: NumericAxis(
                minimum: minimum,
                isVisible: false,
              ),
              tooltipBehavior: _tooltipBehavior,
              // zoomPanBehavior: _zoompan,
              series: <ChartSeries<_ChartData, DateTime>>[
                AreaSeries<_ChartData, DateTime>(
                  dataSource: data,
                  borderDrawMode: BorderDrawMode.top,
                  borderWidth: 2,
                  borderColor: stockColor,
                  xValueMapper: (_ChartData data, _) => data.x,
                  yValueMapper: (_ChartData data, _) => data.y,
                  color: stockColor,
                  gradient: LinearGradient(colors: [
                    stockColor.withOpacity(0.1),
                    stockColor,
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

  Widget Stockinfo(Size size, String stockName, String stockCode,
      int stockPrice, String stockPerc) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                //Firebase 적용사항
                stockName,
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
                //Firebase 적용사항
                stockCode,
                style: TextStyle(
                    color: Colors.grey[700], fontSize: size.width * 0.04),
              )
            ],
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            //Firebase 적용사항
            stockPrice.toString(),
            style: TextStyle(
              color: stockColor,
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
              //Firebase 적용사항
              stockPerc,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: stockColor,
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

  // 하단 위젯 구성
  Widget stockNewsTab(Size size, String msg) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        color: Colors.white,
      ),
      width: size.width * 0.9,
      height: size.height * 0.4,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.02,
            ),
            ListView.separated(
              itemCount: newsDataList.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(color: GREY),
              itemBuilder: (BuildContext context, int index) {
                return stockNews(
                    newsDataList[index]["title"],
                    newsDataList[index]["content"],
                    newsDataList[index]["distinction"]);
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            )
          ],
        ),
      ),
    );
  }

  Widget stockInfoTab(Size size, String msg) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        color: Colors.white,
      ),
      width: size.width * 0.9,
      height: size.height * 0.4,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.02,
            ),
            SizedBox(
              height: size.height * 0.02,
            )
          ],
        ),
      ),
    );
  }

  Widget stockdetail(Size size, String Icon, String Infodetail, String Value) {
    return Container(
      margin:
          EdgeInsets.only(bottom: size.height * 0.03, top: size.height * 0.03),
      child: Row(
        children: [
          SizedBox(
              width: size.width * 0.04,
              height: size.width * 0.04,
              child: (SvgPicture.asset('assets/icons/stock$Icon.svg',
                  semanticsLabel: '$stockIcon', color: CHART_MINUS))),
          SizedBox(width: size.width * 0.02),
          Text(
            Infodetail,
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Color.fromRGBO(91, 99, 106, 1),
                fontFamily: 'ABeeZee',
                fontSize: size.width * 0.04,
                letterSpacing: 0,
                fontWeight: FontWeight.bold,
                height: 1),
          ),
          Expanded(
            child: Text(
              Value,
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: Color.fromRGBO(91, 99, 106, 1),
                  fontFamily: 'ABeeZee',
                  fontSize: size.width * 0.036,
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                  height: 1),
            ),
          )
        ],
      ),
    );
  }

  Widget stockNews(String title, String content, int result) {
    // String? 에러
    if (title == null) {
      return SizedBox();
    }
    if (content == null) {
      return SizedBox();
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            newsResult(result),
          ],
        ),
        SizedBox(
          height: 2,
        ),
        Text(
          content,
          style: TextStyle(
              fontWeight: FontWeight.normal, color: Color(0xff888888)),
        )
      ],
    );
  }

  Widget newsResult(int result) {
    var resultColor;
    var resultBackgrouncolor;
    if (result == null) {
      return Container();
    }
    if (result == 1) {
      resultColor = Color(0xff0EBD8D);
      resultBackgrouncolor = Color(0xffE7F9F4);
    } else if (result == 0) {
      resultColor = Color(0xffEF3641);
      resultBackgrouncolor = Color(0xffF9E7E7);
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        color: resultBackgrouncolor,
      ),
      child: Text(
        (result == 1) ? "호재" : "악재",
        style: TextStyle(
          color: resultColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: getStockInfo(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          firebaseStockData = snapshot.data;
          if (firebaseStockData["perc"][0] == '+') {
            stockColor = CHART_PLUS;
          } else {
            stockColor = CHART_MINUS;
          }
          return FutureBuilder(
            // 종목명 - 상위 클래스에서 받아와야함
            future: chartInit(firebaseStockData["code"] + ".KS"),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (dayData.isNotEmpty) {
                return Scaffold(
                  appBar: mainAppBar(
                    context,
                    "종목 정보",
                    StarButton(context),
                  ),
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Stockmain(size),
                          infoTab(size),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
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
