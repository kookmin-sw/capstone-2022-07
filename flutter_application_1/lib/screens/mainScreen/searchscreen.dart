// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/setting_button.dart';
import 'package:flutter_application_1/screens/mainScreen/stockscreen.dart';
import 'package:flutter_application_1/Components/main_app_bar.dart';
import 'package:flutter_application_1/Color/Color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Components/numFormat.dart';

class Searchscreen extends StatefulWidget {
  Searchscreen({Key? key}) : super(key: key);
  @override
  State<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  FloatingSearchBarController? controller;

  String selectedTerm = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: mainPageAppBar(
        context,
        "검색",
        SettingButton(context),
      ),
      body: SizedBox(
          height: size.height,
          width: size.width,
          child: Stack(children: [
            visitedtitle(size),
            visitedstock(size),
            buildFloatingSearchBar(context, size),
          ])),
    );
  }

  Widget visitedtitle(size) {
    return Positioned(
        // padding: EdgeInsets.only(left : size.width*0.02),
        top: size.width * 0.2,
        left: size.width * 0.04,
        height: size.height * 0.04,
        child: Text('최근 조회 종목',
            style: GoogleFonts.notoSans(
                fontSize: size.width * 0.025,
                fontWeight: FontWeight.bold,
                height: size.width * 0.005)));
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

  Widget visitedstock(Size size) {
    return FutureBuilder<List<dynamic>>(
        future: _getvisitedstockanddata(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<dynamic> visitedstocklist = snapshot.data ?? [];
            if (visitedstocklist[0].isEmpty) {
              return Stack(
                children: [
                  Positioned(
                      top: size.width * 0.2,
                      left: size.width * 0.04,
                      child: Container(
                          width: size.width * 0.15,
                          height: size.height * 0.03,
                          color: Color.fromRGBO(249, 249, 249, 1))),
                  Center(
                      child: Text(
                    '최근 조회한 종목이 없습니다.',
                    style: TextStyle(
                      fontSize: size.width * 0.05,
                      color: GREY,
                    ),
                  ))
                ],
              );
            } else {
              return visitedstockview(
                  size, visitedstocklist[0], visitedstocklist[1]);
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget favoritestock(Size size, bool res) {
    if (res == true) {
      return Container(child: Icon(Icons.star_outlined, color: Colors.amber));
    } else {
      return Container(child: Icon(Icons.star_outline, color: Colors.amber));
    }
  }

  Widget visitedstockview(Size size, List<Map<String, dynamic>>? visitedlist,
      List<dynamic> favoritelist) {
    List<Map<String, dynamic>> stocklist = visitedlist!.reversed.toList();
    if (stocklist.isEmpty) {
      return Container();
    } else {
      return Positioned(
          top: size.width * 0.27,
          left: size.width * 0.03,
          child: SizedBox(
              height: size.height * 0.8,
              width: size.width * 0.94,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: visitedlist.length,
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

                  return Column(
                    children: [
                      Container(
                          height: size.height * 0.06,
                          color: Colors.white,
                          padding: EdgeInsets.only(left: size.width * 0.02),
                          child: Row(
                            children: [
                              InkWell(
                                child: Container(
                                    width: size.width * 0.38,
                                    height: size.height * 0.06,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(stocklist[index]['stockName'],
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.notoSans(
                                                fontSize: size.width * 0.03,
                                                height: size.width * 0.005,
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis),
                                        Text(
                                          stocklist[index]['stockCode'],
                                          style: GoogleFonts.notoSans(
                                              fontSize: size.width * 0.025,
                                              fontWeight: FontWeight.normal,
                                              textStyle: TextStyle(
                                                  color: Colors.grey[600])),
                                        )
                                      ],
                                    )),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return Stockscreen(
                                          stockName: stocklist[index]
                                              ['stockName'],
                                        );
                                      },
                                    ),
                                  ).then((_) => setState(() {}));
                                },
                              ),
                              Container(
                                  width: size.width * 0.2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      //stockPrice
                                      Container(
                                          child: Text(
                                        stockPrice,
                                        style: TextStyle(
                                          fontFamily: 'Content',
                                          fontSize: size.width * 0.03,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.bold,
                                          height: 1.5,
                                        ),
                                        textAlign: TextAlign.end,
                                      )),
                                      //stockPerChange
                                      Container(
                                          margin: EdgeInsets.only(
                                              bottom: size.height * 0.01),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                  child: Icon((() {
                                                if (stockColor == CHART_PLUS) {
                                                  return Icons
                                                      .arrow_drop_up_outlined;
                                                } else if (stockColor ==
                                                    CHART_MINUS) {
                                                  return Icons
                                                      .arrow_drop_down_outlined;
                                                } else {
                                                  return Icons.remove;
                                                }
                                              })(),
                                                      color: stockColor,
                                                      size: size.width * 0.05)),
                                              Text(
                                                stockChange,
                                                style: TextStyle(
                                                  color: stockColor,
                                                  fontFamily: 'Content',
                                                  fontSize: size.width * 0.024,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1,
                                                ),
                                              )
                                            ],
                                          ))
                                    ],
                                  )),
                              Container(
                                  width: size.width * 0.09,
                                  height: size.height * 0.03,
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
                                      vertical: size.height * 0.013,
                                      horizontal: size.width * 0.015),
                                  child: Text(stockPerChange,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.width * 0.02,
                                          height: 2,
                                          fontWeight: FontWeight.bold))),
                              SizedBox(width: size.width * 0.05),
                              GestureDetector(
                                child: favoritestock(size, initstar),
                                onTap: () async {
                                  setState(() {
                                    initstar = !initstar;
                                  });
                                  if (initstar == false) {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .update({
                                      "favorite": FieldValue.arrayRemove(
                                          [stocklist[index]['stockName']])
                                    });
                                  } else {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .update({
                                      "favorite": FieldValue.arrayUnion(
                                          [stocklist[index]['stockName']])
                                    });
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
                                  useruid = await FirebaseAuth
                                      .instance.currentUser!.uid;
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
                          )),
                      Container(
                        height: 1.0,
                        width: size.width,
                        color: Colors.grey[200],
                      )
                    ],
                  );
                },
              )));
    }
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
        height: size.height * 0.37 * 0.1,
        margin:
            EdgeInsets.only(left: size.width * 0.05, right: size.width * 0.03),
        child: Row(
          children: [
            Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stockname, //Firebase 적용사항
                  style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontFamily: 'ABeeZee',
                      fontSize: size.width * 0.03,
                      fontWeight: FontWeight.bold,
                      height: size.width * 0.003,
                      overflow: TextOverflow.ellipsis),
                ),
                Text(
                  stockCode,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: 'ABeeZee',
                    fontSize: size.width * 0.021,
                    fontWeight: FontWeight.normal,
                  ),
                )
              ],
            )),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Text(
                        '$stockprice', //Firebase 적용사항
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontFamily: 'Content',
                            fontSize: size.width * 0.03,
                            fontWeight: FontWeight.normal,
                            height: 1.2),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              child: Icon((() {
                            if (color == CHART_PLUS) {
                              return Icons.arrow_drop_up_outlined;
                            } else if (color == CHART_MINUS) {
                              return Icons.arrow_drop_down_outlined;
                            } else {
                              return Icons.remove;
                            }
                          })(), color: color, size: size.width * 0.025)),
                          Text(
                            stockChange, //Firebase 적용사항
                            style: TextStyle(
                                color: color,
                                fontFamily: 'Content',
                                fontSize: size.width * 0.02,
                                fontWeight: FontWeight.normal,
                                height: 1.2),
                          ),
                        ],
                      )
                    ],
                  ),
                  Container(
                      width: size.width * 0.09,
                      height: size.height * 0.06,
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
                          vertical: size.height * 0.003,
                          horizontal: size.width * 0.015),
                      child: Text(stockPerChange.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width * 0.02,
                              fontWeight: FontWeight.bold,
                              height: size.width * 0.005)))
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
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.data!.docs.length == 0 ||
                  snapshot.data!.docs.length > 300) {
                return Container();
              } else {
                for (int i = 0; i < snapshot.data!.docs.length; i++) {
                  increaseList.add(
                      snapshot.data.docs[i].data() as Map<String, dynamic>);
                }
                print(increaseList);
                return searchStockList(size, increaseList);
              }
              // return _buildList(context, snapshot.data);
            }
          },
        );
      },
    );
  }
}
