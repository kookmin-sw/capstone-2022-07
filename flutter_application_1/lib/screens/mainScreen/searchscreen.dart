// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/indicator.dart';
import 'package:flutter_application_1/Components/setting_button.dart';
import 'package:flutter_application_1/screens/mainScreen/stockscreen.dart';
import 'package:flutter_application_1/Components/main_app_bar.dart';
import 'package:flutter_application_1/Color/Color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Components/numFormat.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class visitedstock extends StatefulWidget {
  const visitedstock(this.parentSize, {Key? key}) : super(key: key);
  final Size parentSize;
  @override
  State<visitedstock> createState() => _visitedstockState();
}

class _visitedstockState extends State<visitedstock> {
  Widget visitedtitle(size) {
    return Container(
      alignment: Alignment.topLeft,
      margin:
          EdgeInsets.only(left: size.width * 0.01, bottom: size.height * 0.01),
      child: Text(
        '최근 조회 종목',
        style: GoogleFonts.notoSans(
            fontSize: size.width * 0.04,
            fontWeight: FontWeight.bold,
            height: size.width * 0.005),
      ),
    );
  }

  Widget favoritestock(Size size, bool res) {
    if (res == true) {
      return Icon(Icons.star_outlined, color: Colors.amber);
    } else {
      return Icon(Icons.star_outline, color: Colors.amber);
    }
  }

  //주식 정보를 가져옴
  Future<List<Map<String, dynamic>>> _getstockInfo(List<dynamic> list) async {
    List<Map<String, dynamic>> stockcardlist = [];
    Map<String, dynamic> stockdata;

    for (var element in list) {
      var userstockinfo = await FirebaseFirestore.instance
          .collection('stock')
          .where("stockName", isEqualTo: "${element}")
          .get();
      stockdata = userstockinfo.docs[0].data();
      stockcardlist.add(stockdata);
    }
    return stockcardlist;
  }

  Widget visitedstockview(Size size, List<Map<String, dynamic>>? visitedlist,
      List<dynamic> favoritelist) {
    List<Map<String, dynamic>> stocklist = visitedlist!.reversed.toList();
    if (stocklist.isEmpty) {
      return Container();
    } else {
      return SingleChildScrollView(
        child: Container(
          width: size.width * 0.92,
          height: size.height * 0.8,
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
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: visitedlist.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(color: GREY),
            itemBuilder: (BuildContext context, int index) {
              String name = stocklist[index]['stockName'];

              // index -= 1;
              bool initstar;
              if (favoritelist.contains(stocklist[index]['stockName'])) {
                initstar = true;
              } else {
                initstar = false;
              }
              late Color stockColor;
              if (stocklist[index]['stockPerChange'] > 0) {
                stockColor = CHART_PLUS;
              } else if (stocklist[index]['stockPerChange'] < 0) {
                stockColor = CHART_MINUS;
              } else {
                stockColor = Color.fromARGB(255, 120, 119, 119);
              }
              String stockPrice =
                  intlprice.format(stocklist[index]['stockPrice']);
              String stockChange =
                  intlprice.format(stocklist[index]['stockChange'].abs());
              String stockPerChange =
                  intlperc.format(stocklist[index]['stockPerChange']) + "%";

              return Container(
                height: size.height * 0.07,
                padding: EdgeInsets.only(
                    left: size.width * 0.03, right: size.width * 0.03),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name, //Firebase 적용사항
                          style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.normal,
                              overflow: TextOverflow.ellipsis),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Text(
                          stocklist[index]["stockCode"],
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: size.width * 0.03,
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  stockPrice, //Firebase 적용사항
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontSize: size.width * 0.035,
                                      height: size.height * 0.002),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon((() {
                                      if (stockColor == CHART_PLUS) {
                                        return Icons.arrow_drop_up_outlined;
                                      } else if (stockColor == CHART_MINUS) {
                                        return Icons.arrow_drop_down_outlined;
                                      } else {
                                        return Icons.remove;
                                      }
                                    })(),
                                        color: stockColor,
                                        size: size.width * 0.05),
                                    Text(
                                      stockChange, //Firebase 적용사항
                                      style: TextStyle(
                                        color: stockColor,
                                        fontSize: size.width * 0.03,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(width: size.width * 0.02),
                            Container(
                              width: size.width * 0.13,
                              height: size.height * 0.035,
                              padding: EdgeInsets.only(
                                bottom: size.height * 0.005,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                  bottomLeft: Radius.circular(4),
                                  bottomRight: Radius.circular(4),
                                ),
                                color: stockColor,
                              ),
                              margin: EdgeInsets.symmetric(
                                  vertical: size.height * 0.005,
                                  horizontal: size.width * 0.015),
                              child: Center(
                                child: FittedBox(
                                  child: Text(stockPerChange,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.height * 0.015,
                                        height: 2,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return Stockscreen(
                                  stockName: stocklist[index]['stockName'],
                                  stockCode: stocklist[index]['stockCode'],
                                );
                              },
                            ),
                          );
                        },
                        behavior: HitTestBehavior.opaque,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.03,
                    ),
                    GestureDetector(
                      child: favoritestock(size, initstar),
                      onTap: () async {
                        setState(() {
                          initstar = !initstar;
                        });
                        if (initstar == false) {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({
                            "favorite": FieldValue.arrayRemove(
                                [stocklist[index]['stockName']])
                          });
                          await FirebaseMessaging.instance.unsubscribeFromTopic(
                              stocklist[index]['stockCode']);
                        } else {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({
                            "favorite": FieldValue.arrayUnion(
                                [stocklist[index]['stockName']])
                          });
                          await FirebaseMessaging.instance
                              .subscribeToTopic(stocklist[index]['stockCode']);
                        }
                      },
                    ),
                    SizedBox(width: size.width * 0.02),
                    InkWell(
                      child: Icon(
                        Icons.close,
                      ),
                      onTap: () async {
                        String useruid;
                        useruid = await FirebaseAuth.instance.currentUser!.uid;
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(useruid)
                            .update({
                          "visited": FieldValue.arrayRemove([name])
                        });
                        setState(() {});
                      },
                    )
                  ],
                ),
              );
            },
          ),
        ),
      );
    }
  }

  //사용자의 visited와 favorite 정보를 가져옴
  Future<List<dynamic>> _getvisitedstockanddata() async {
    String useruid = FirebaseAuth.instance.currentUser!.uid;
    var user =
        await FirebaseFirestore.instance.collection('users').doc(useruid).get();
    List<dynamic> visitedlist = user['visited'];
    List<dynamic> favoritelist = user['favorite'];

    var data = await _getstockInfo(visitedlist);
    return [data, favoritelist];
  }

  Future<List<dynamic>> getvisited() {
    return _getvisitedstockanddata();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: getvisited(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<dynamic> visitedstocklist = snapshot.data ?? [];
            if (visitedstocklist[0].isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      color: GREY,
                      size: widget.parentSize.height * 0.1,
                    ),
                    SizedBox(
                      height: widget.parentSize.height * 0.05,
                    ),
                    Text(
                      "최근 검색 목록이 없습니다.",
                      style: TextStyle(
                        fontSize: widget.parentSize.width * 0.07,
                        color: GREY,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Positioned(
                top: widget.parentSize.height * 0.08,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    visitedtitle(widget.parentSize),
                    visitedstockview(widget.parentSize, visitedstocklist[0],
                        visitedstocklist[1]),
                  ],
                ),
              );
            }
          } else {
            return Center(child: indicator());
          }
        });
  }
}

class Searchscreen extends StatefulWidget {
  Searchscreen({Key? key}) : super(key: key);
  @override
  State<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  FloatingSearchBarController? controller;

  String selectedTerm = "empty";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: mainPageAppBar(
        context,
        "검색",
      ),
      body: SizedBox(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              visitedstock(size),
              buildFloatingSearchBar(context, size),
            ],
            alignment: Alignment.topCenter,
          )),
    );
  }

  Widget searchStockList(Size size, List<Map<String, dynamic>> list) {
    return SingleChildScrollView(
      child: Container(
        width: size.width * 0.9,
        // height: double.infinity,
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
          shrinkWrap: true,
          itemCount: list.length,
          physics: ClampingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return searchStock(
                size,
                list[index]['stockName'],
                list[index]['stockCode'],
                list[index]['stockChange'],
                list[index]['stockPrice'],
                list[index]['stockPerChange']);
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(color: GREY),
        ),
      ),
    );
  }

  Widget searchStock(Size size, String stockname, var stockCode,
      var stockChange, var stockprice, var stockPerChange) {
    Color color;
    if (stockPerChange > 0) {
      color = CHART_PLUS;
    } else if (stockPerChange < 0) {
      color = CHART_MINUS;
    } else {
      color = GREY;
    }
    stockprice = intlprice.format(stockprice);
    stockChange = intlprice.format(stockChange.abs());
    stockPerChange = intlperc.format(stockPerChange) + "%";

    return GestureDetector(
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.4 * 0.15,
        margin:
            EdgeInsets.only(left: size.width * 0.05, right: size.width * 0.03),
        child: Row(
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stockname, //Firebase 적용사항
                    style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.normal,
                        overflow: TextOverflow.ellipsis),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Text(
                    stockCode,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: size.width * 0.03,
                      fontWeight: FontWeight.normal,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$stockprice', //Firebase 적용사항
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: size.width * 0.035,
                            height: size.height * 0.002),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon((() {
                            if (color == CHART_PLUS) {
                              return Icons.arrow_drop_up_outlined;
                            } else if (color == CHART_MINUS) {
                              return Icons.arrow_drop_down_outlined;
                            } else {
                              return Icons.remove;
                            }
                          })(), color: color, size: size.width * 0.05),
                          Text(
                            '$stockChange', //Firebase 적용사항
                            style: TextStyle(
                              color: color,
                              fontSize: size.width * 0.03,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(width: size.width * 0.02),
                  Container(
                    width: size.width * 0.13,
                    height: size.height * 0.035,
                    padding: EdgeInsets.only(
                      bottom: size.height * 0.005,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                      color: color,
                    ),
                    margin: EdgeInsets.symmetric(
                        vertical: size.height * 0.005,
                        horizontal: size.width * 0.015),
                    child: Center(
                      child: FittedBox(
                        child: Text(stockPerChange,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.height * 0.015,
                              height: 2,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () async {
        String useruid = FirebaseAuth.instance.currentUser!.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(useruid)
            .update({
          "visited": FieldValue.arrayUnion([stockname])
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Stockscreen(
                stockName: stockname,
                stockCode: stockCode,
              );
            },
          ),
        );
      },
      behavior: HitTestBehavior.opaque,
    );
  }

  Widget buildFloatingSearchBar(BuildContext context, Size size) {
    List<Map<String, dynamic>> increaseList = [];
    return FloatingSearchBar(
      controller: controller,
      body: FloatingSearchBarScrollNotifier(child: Container()),
      transition: CircularFloatingSearchBarTransition(),
      physics: BouncingScrollPhysics(),
      hint: '검색할 종목을 입력해 주세요',
      actions: [
        FloatingSearchBarAction.searchToClear(),
      ],
      debounceDelay: Duration(milliseconds: 500),
      onQueryChanged: (query) {
        setState(
          () {
            selectedTerm = query.toUpperCase();
          },
        );
      },
      builder: (context, transition) {
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('stock')
              .where("stockName", isGreaterThanOrEqualTo: selectedTerm)
              .where("stockName", isLessThanOrEqualTo: selectedTerm + "\uF7FF")
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.data!.docs.length == 0 ||
                  snapshot.data!.docs.length > 300) {
                return Container();
              } else {
                for (int i = 0; i < snapshot.data!.docs.length; i++) {
                  increaseList.add(
                      snapshot.data.docs[i].data() as Map<String, dynamic>);
                }
                return searchStockList(size, increaseList);
              }
            }
          },
        );
      },
    );
  }
}
