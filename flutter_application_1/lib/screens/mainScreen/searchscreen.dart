// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/setting_button.dart';
import 'package:flutter_application_1/screens/mainScreen/stockscreen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_1/Components/main_app_bar.dart';
import 'package:flutter_application_1/Color/color.dart';
import 'package:flutter_application_1/Components/stock_list.dart';
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
            visitedstock(size),
            visitedtitle(size),
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
        // color:Colors.grey[100],
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
            return visitedstockview(
                size, visitedstocklist[0], visitedstocklist[1]);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget favoritestock(Size size, bool res) {
    String val;
    if (res == true) {
      val = "on";
    } else {
      val = "off";
    }
    return Container(
        child: SvgPicture.asset('assets/icons/searchstar${val}.svg',
            width: size.width * 0.05));
  }

  Widget visitedstockview(Size size, List<Map<String, dynamic>>? visitedlist,
      List<dynamic> favoritelist) {
    List<Map<String, dynamic>> stocklist = visitedlist!.reversed.toList();
    if (stocklist == null) {
      return Text('최근 조회 목록 없음');
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
                                    width: size.width * 0.75,
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
                                                fontWeight: FontWeight.bold)),
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
                                  );
                                },
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
                              VerticalDivider(
                                color: Colors.grey[200],
                                thickness: 0.5,
                              ),
                              SizedBox(width: size.width * 0.015),
                              InkWell(
                                child: SvgPicture.asset(
                                  'assets/icons/searchclose.svg',
                                  width: size.width * 0.03,
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
              list[index]['stockPerChange'],
              list[index]['stockPrice'],
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(color: GREY),
        ),
      ),
    );
  }

  Widget searchStock(
      Size size, String stockname, var stockperc, var stockprice) {
    Color color;
    if (stockperc > 0) {
      color = CHART_PLUS;
    } else if (stockperc < 0) {
      color = CHART_MINUS;
    } else {
      color = GREY;
    }
    stockprice = intlprice.format(stockprice);
    return GestureDetector(
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.37 * 0.1,
        margin:
            EdgeInsets.only(left: size.width * 0.05, right: size.width * 0.03),
        child: Row(
          children: [
            Text(
              stockname, //Firebase 적용사항
              style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontFamily: 'ABeeZee',
                  fontSize: size.width * 0.035,
                  fontWeight: FontWeight.bold,
                  height: 1.2),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
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
                print(selectedTerm);
                print(snapshot.data.docs.length);
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
