// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_unnecessary_containers, non_constant_identifier_names, prefer_const_constructors_in_immutables, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Color/Color.dart';

import 'package:flutter_application_1/Components/main_app_bar.dart';
import 'package:flutter_application_1/Components/setting_button.dart';
import 'package:flutter_application_1/screens/mainScreen/stockscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter_application_1/Components/numFormat.dart';

class Mainscreen extends StatefulWidget {
  Mainscreen({Key? key}) : super(key: key);

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> _getList(
      List<Map<String, dynamic>> increaseList,
      List<Map<String, dynamic>> decreaseList,
      List<Map<String, dynamic>> positiveList,
      List<Map<String, dynamic>> negativeList,
      List<Map<String, dynamic>> mainList,
      List<Map<String, dynamic>> toprateNewslist) async {
    await firestore
        .collection('stock')
        .orderBy("stockPerChange",
            descending: true) // stockPerChange -> DailyNewsCount
        .limit(5)
        .get()
        .then(
      (QuerySnapshot qs) {
        for (var doc in qs.docs) {
          Map<String, dynamic> increase = doc.data() as Map<String, dynamic>;
          increaseList.add(increase);
        }
      },
    );

    await firestore
    .collection('stock')
    .orderBy("DayNewsCount",descending: true)
    .limit(3)
    .get()
    .then(
        (QuerySnapshot qs){
          for(var doc in qs.docs){
            toprateNewslist.add(doc.data() as Map<String,dynamic>);
          }
        }
    );

    await firestore
        .collection('stock')
        .orderBy(
          "stockPerChange",
        )
        .limit(20)
        .get()
        .then(
      (QuerySnapshot qs) {
        for (var doc in qs.docs) {
          Map<String, dynamic> decrease = doc.data() as Map<String, dynamic>;
          decrease.forEach((key, value) {
            if (key == "stockPerChange") {
              if (!value.isNaN) {
                decreaseList.add(decrease);
              }
            }
            // decreaseList.add(decrease);
          });
        }
      },
    );

    await firestore
        .collection('stock')
        .orderBy("TimePerPositiveNewsCount", descending: true)
        .limit(5)
        .get()
        .then(
      (QuerySnapshot qs) {
        for (var doc in qs.docs) {
          Map<String, dynamic> positive = doc.data() as Map<String, dynamic>;
          positiveList.add(positive);
        }
      },
    );

    await firestore
        .collection('stock')
        .orderBy("TimePerNegativeNewsCount", descending: true)
        .limit(5)
        .get()
        .then(
      (QuerySnapshot qs) {
        for (var doc in qs.docs) {
          Map<String, dynamic> negative = doc.data() as Map<String, dynamic>;
          negativeList.add(negative);
        }
      },
    );

    await _getMainList(mainList);
  }

  Future<void> _getMainList(List<Map<String, dynamic>?> list) async {
    var docSnapshot = await firestore.collection('stock').doc("코스피").get();
    list.add(docSnapshot.data());
    docSnapshot = await firestore.collection('stock').doc("코스닥").get();
    list.add(docSnapshot.data());
  }

  Widget mainStockList(Size size, List<Map<String, dynamic>> list) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
                left: size.width * 0.01,
                top: size.height * 0.01,
                bottom: size.height * 0.01),
            child: Text(
              // api 수정 필요함
              list[0]["updatedTime"] + " 기준",
              style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 0.7),
                fontFamily: 'Content',
                fontSize: size.width * 0.025,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ) // Firebase 적용 사항
          ,
          Container(
            width: size.width * 0.9,
            height: size.height * 0.11,
            padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
            child: ListView.separated(
              itemCount: 2,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return mainStock(
                  size,
                  list[index]['stockName'],
                  list[index]['stockPerChange'],
                  list[index]['stockPrice'],
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(color: GREY),
            ),
          ),
        ],
      ),
    );
  }

  Widget mainStock(Size size, String stockname, var stockperc, var stockprice) {
    Color color;
    if (stockperc > 0) {
      color = CHART_PLUS;
    } else if (stockperc < 0) {
      color = CHART_MINUS;
    } else {
      color = GREY;
    }
    stockprice = intlmarket.format(stockprice);
    stockperc = intlperc.format(stockperc) + "%";
    return GestureDetector(
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.37 * 0.1,
        margin:
            EdgeInsets.only(left: size.width * 0.05, right: size.width * 0.03),
        child: Row(
          children: [
            Container(
              child: Text(
                stockname, //Firebase 적용사항
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'ABeeZee',
                    fontSize: size.width * 0.035,
                    fontWeight: FontWeight.bold,
                    height: 1.2),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Text(
                          '$stockperc', //Firebase 적용사항
                          style: TextStyle(
                              color: color,
                              fontFamily: 'Content',
                              fontSize: size.width * 0.03,
                              fontWeight: FontWeight.normal,
                              height: 1.2),
                        ),
                        Text(
                          '$stockprice', //Firebase 적용사항
                          style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Content',
                              fontSize: size.width * 0.02,
                              fontWeight: FontWeight.normal,
                              height: 1.2),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Stockscreen(
                stockName: stockname,
              );
            },
          ),
        );
      },
      behavior: HitTestBehavior.opaque,
    );
  }

  // 주요지수를 알려주는 위젯
  // 기사 많이 나온 종목
  Widget Topstocklist(Size size, List<Map<String, dynamic>> list) {
    // 특정 콜렉션 참조
    return Container(
            width: size.width * 0.9,
            height: size.height * 0.25,
            padding: EdgeInsets.only(top: size.height * 0.01),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              color: Color.fromRGBO(255, 255, 255, 1.0),
            ),
            child: ListView.separated(
              itemCount: 5,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Topstock(
                  size,
                  list[index]['stockName'],
                  list[index]['stockPerChange'],
                  list[index]['stockPrice'],
                  list[index]['DayNewsCount'],
                  list[index]['stockCode'],
                  list[index]['stockChange']
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(color: GREY),
            ),
          );
  }

  Widget Topstock(Size size, String stockname, var stockperc, var stockprice,
      var newscount, var stockCode, var stockChange) {
    Color color;
    if (stockperc > 0) {
      color = CHART_PLUS;
    } else if (stockperc < 0) {
      color = CHART_MINUS;
    } else {
      color = GREY;
    }
    stockprice = intlprice.format(stockprice);
    stockperc = intlperc.format(stockperc) + "%";
    stockChange = intlprice.format(stockChange);
    return GestureDetector(
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.37 * 0.1,
        margin:
            EdgeInsets.only(left: size.width * 0.05, right: size.width * 0.03),
        child: Row(
          children: [
            Container(
              child : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stockname, //Firebase 적용사항
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'ABeeZee',
                    fontSize: size.width * 0.025,
                    fontWeight: FontWeight.bold,
                    height : size.height*0.002,
                    overflow : TextOverflow.ellipsis)),
              Text(
                stockCode,
                style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: 'ABeeZee',
                    fontSize: size.width * 0.02,
                    height : size.height*0.002,
                    fontWeight: FontWeight.normal),
                // textAlign: TextAlign.left,
              ),

          ],
        )
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Text(
                          '$stockprice'
                          , //Firebase 적용사항
                          style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Content',
                              fontSize: size.width * 0.025,
                              fontWeight: FontWeight.bold,
                              height:size.height * 0.002),
                        ),
                        Container(
                          child : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                  child: Icon((
                                          () {
                                        if(color == CHART_PLUS){
                                          return Icons.arrow_drop_up_outlined;
                                        }else if(color ==CHART_MINUS){
                                          return Icons.arrow_drop_down_outlined;
                                        }else {
                                          return Icons.remove;
                                        }
                                      })(),
                                      color : color,
                                      size: size.width*0.02
                                  )
                              ),
                              Text(
                                '$stockperc', //Firebase 적용사항
                                style: TextStyle(
                                    color: color,
                                    fontFamily: 'Content',
                                    fontSize: size.width * 0.02,
                                    fontWeight: FontWeight.normal,),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          )
                        )

                      ],
                    ),

                  ),SizedBox(width: size.width*0.02),
                  Container(
                      width : size.width*0.09,
                      height: size.height*0.03,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight:  Radius.circular(4),
                          bottomLeft: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                        color: color,
                      ),
                      margin: EdgeInsets.symmetric(vertical: size.height*0.005, horizontal: size.width*0.015),
                      child : Text(
                          stockperc,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width*0.02,
                              height: 2,
                              fontWeight: FontWeight.bold
                          )
                      )
                  ),
                  Container(
                    width: size.width * 0.1,
                    child: Text(
                      '$newscount개', //Firebase 적용사항
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'ABeeZee',
                          fontSize: size.width * 0.035,
                          fontWeight: FontWeight.normal,
                          height: 1.2),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Stockscreen(
                stockName: stockname,
              );
            },
          ),
        );
      },
      behavior: HitTestBehavior.opaque,
    );
  }

  Widget rankingTab(
      Size size,
      List<Map<String, dynamic>> increaseList,
      List<Map<String, dynamic>> decreaseList,
      String title,
      String menu1,
      String menu2) {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.01),
      width: size.width * 0.9,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        color: Color.fromRGBO(255, 255, 255, 1),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(size.width * 0.01),
            padding: EdgeInsets.only(
                left: size.width * 0.03, top: size.height * 0.01),
            // alignment: Alignment.topLeft,
            child: Text(
              title,
              style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1),
                fontFamily: 'Content',
                fontSize: size.width * 0.05,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
          ),
          Divider(),
          Container(
            height: size.height * 0.35,
            child: ContainedTabBarView(
              tabBarProperties: TabBarProperties(
                height: size.height * 0.04,
                labelStyle: TextStyle(
                    color: Color(0xff0039A4), fontSize: size.width * 0.1 * 0.3),
                labelColor: Color(0xff0039A4),
                unselectedLabelColor: Colors.grey[400],
                indicatorColor: Color(0xff0039A4),
              ),
              tabs: [
                Text(menu1),
                Text(menu2),
              ],
              views: [
                Topstocklist(size, increaseList),
                Topstocklist(size, decreaseList)
              ],
              onChange: (index) => print(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget TopratenewsListTab(Size size, List<Map<String, dynamic>> topList){

    return Container();
  }
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> increaseList = [];
    List<Map<String, dynamic>> decreaseList = [];
    List<Map<String, dynamic>> positiveList = [];
    List<Map<String, dynamic>> negativeList = [];
    List<Map<String, dynamic>> mainStocklist = [];
    List<Map<String, dynamic>> toprateNewslist = [];
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: mainPageAppBar(
        context,
        "홈",
        SettingButton(context),
      ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.topCenter,
          child: FutureBuilder(
            future: _getList(increaseList, decreaseList, positiveList,
                negativeList, mainStocklist, toprateNewslist),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      mainStockList(size, mainStocklist),
                      TopratenewsListTab(size, toprateNewslist),
                      rankingTab(size, increaseList, decreaseList, "시세 순위",
                          "상승 종목", "하락 종목"),
                      rankingTab(size, positiveList, negativeList, "뉴스 순위",
                          "호재 순위", "악재 순위"),
                      SizedBox(height: size.height * 0.03),
                      // Stockindex(size),
                    ],
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
