// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_const_literals_to_create_immutables, non_constant_identifier_names, prefer_const_constructors_in_immutables, constant_identifier_names, prefer_typing_uninitialized_variables, unnecessary_string_interpolations, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Color/color.dart';
import 'package:flutter_application_1/Components/indicator.dart';
import 'package:flutter_application_1/Components/main_app_bar.dart';
import 'package:flutter_application_1/Components/setting_button.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/Register/function.dart';
import 'package:flutter_application_1/Components/numFormat.dart';
import 'package:flutter_application_1/screens/mainScreen/stockscreen.dart';

class InterestScreen extends StatefulWidget {
  InterestScreen({Key? key}) : super(key: key);

  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<dynamic>> _getstockList() async {
    Map<String, dynamic> userdocdata =
        await findUserByUid(FirebaseAuth.instance.currentUser!.uid)
            as Map<String, dynamic>;

    // user의 device token

    List<dynamic> nlist = userdocdata['favorite'];
    return nlist;
  }

  Future<List<Map<String, dynamic>>> _getstockInfo(List<dynamic> nlist) async {
    List<Map<String, dynamic>> stockcardlist = [];
    Map<String, dynamic> stockdata;

    for (var element in nlist) {
      var userstockinfo = await firestore
          .collection('stock')
          .where("stockName", isEqualTo: "${element}")
          .get();

      try {
        stockdata = userstockinfo.docs[0].data();
      } on RangeError {
        return [];
      }

      stockcardlist.add(stockdata);
    }

    return stockcardlist;
  }

  Future<List<Map<String, dynamic>>> customFuture() async {
    var userstockinfo = await _getstockList();
    if (userstockinfo == null) {
      return [];
    } else {
      var stockinfo = await _getstockInfo(userstockinfo);
      return stockinfo;
    }
  }

  Widget exceptCospiCosdaq(
      Size size, String stockName, String marketCapKor, Color color) {
    if (stockName != "코스피" && stockName != "코스닥") {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(255, 255, 255, 0.25),
                offset: Offset(0, 4),
                blurRadius: 4)
          ],
          color: Color.fromRGBO(249, 249, 249, 1),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.03, vertical: size.height * 0.01),
        child: Text(
          '시가총액 : $marketCapKor',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontSize: size.width * 0.03,
            letterSpacing: 0,
            fontWeight: FontWeight.normal,
            height: 1,
          ),
        ),
      );
    }

    return Container();
  }

  Widget Stockcard(
      BuildContext context,
      Size size,
      String name,
      var price,
      var stockChange,
      var stockperc,
      var volume,
      var marketCap,
      String stockCode) {
    Color color;
    if (stockperc > 0) {
      color = CHART_PLUS;
    } else if (stockperc < 0) {
      color = CHART_MINUS;
    } else {
      color = GREY;
    }

    if (name != "코스피" && name != "코스닥") {
      price = intlprice.format(price);
      stockChange = intlchange.format(stockChange);
    }
    stockperc = intlperc.format(stockperc) + "%";
    volume = intlvol.format(volume);
    String marketCapKor = marketCapFormat(marketCap);

    if (marketCapKor.length > 16) {
      marketCapKor = marketCapKor.split('').reversed.join();
      marketCapKor = marketCapKor.substring(
          marketCapKor.indexOf('억'), marketCapKor.length);
      marketCapKor = marketCapKor.split('').reversed.join();
    } else if (marketCapKor.length <= 16 && marketCapKor.length > 5) {
      marketCapKor = marketCapKor.split('').reversed.join();
      marketCapKor = marketCapKor.substring(
          marketCapKor.indexOf('만'), marketCapKor.length);
      marketCapKor = marketCapKor.split('').reversed.join();
    }

    return Container(
      height: size.height * 0.185,
      width: size.width * 0.9,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(color: Colors.grey, offset: Offset(1, 1), blurRadius: 1)
        ],
        color: Color.fromRGBO(255, 255, 255, 1),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.03, vertical: size.height * 0.005),
      margin: EdgeInsets.only(bottom: size.height * 0.03),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: size.height * 0.01),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(width: size.width * 0.03),
                Expanded(
                  child: Text(
                    name,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: const Color.fromRGBO(0, 0, 0, 1),
                      fontSize: size.width * 0.035,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1,
                    ),
                  ),
                ),
                InkWell(
                  child: Icon(Icons.close),
                  onTap: () async {
                    setState(() {});
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update({
                      "favorite": FieldValue.arrayRemove([name])
                    });
                  },
                )
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: size.width * 0.01, top: size.height * 0.02),
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                          bottomLeft: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(255, 255, 255, 0.25),
                              offset: Offset(0, 4),
                              blurRadius: 4)
                        ],
                        color: Color.fromRGBO(249, 249, 249, 1),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.03,
                          vertical: size.height * 0.01),
                      child: Text(
                        '주가 : $price',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: color,
                          fontSize: size.width * 0.03,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1,
                        ),
                      ),
                    ),
                    SizedBox(width: size.width * 0.03),
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                          bottomLeft: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(255, 255, 255, 0.25),
                              offset: Offset(0, 4),
                              blurRadius: 4)
                        ],
                        color: Color.fromRGBO(249, 249, 249, 1),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.03,
                          vertical: size.height * 0.01),
                      child: Text(
                        '등락 : ' + stockChange.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: color,
                          fontSize: size.width * 0.03,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1,
                        ),
                      ),
                    ),
                    SizedBox(width: size.width * 0.03),
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                          bottomLeft: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(255, 255, 255, 0.25),
                              offset: Offset(0, 4),
                              blurRadius: 4)
                        ],
                        color: Color.fromRGBO(249, 249, 249, 1),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.03,
                          vertical: size.height * 0.01),
                      child: Text(
                        '대비(등락) : ' + stockperc.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: color,
                          fontSize: size.width * 0.03,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.015),
              Container(
                padding: EdgeInsets.only(left: size.width * 0.01),
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                          bottomLeft: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(255, 255, 255, 0.25),
                              offset: Offset(0, 4),
                              blurRadius: 4)
                        ],
                        color: Color.fromRGBO(249, 249, 249, 1),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.03,
                          vertical: size.height * 0.01),
                      child: Text(
                        '거래량 : $volume',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: color,
                          fontSize: size.width * 0.03,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1,
                        ),
                      ),
                    ),
                    SizedBox(width: size.width * 0.03),
                    exceptCospiCosdaq(size, name, marketCapKor, color),
                    const Expanded(
                      child: SizedBox(),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Stockscreen(
                                stockName: name,
                                stockCode: stockCode,
                              );
                            },
                          ),
                        ).then((_) => setState(() {}));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.03,
                            vertical: size.height * 0.005),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          color: const Color.fromRGBO(249, 249, 249, 1),
                          boxShadow: [
                            const BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.25),
                                offset: Offset(0, 4),
                                blurRadius: 4)
                          ],
                          border: Border.all(
                            color: const Color.fromRGBO(25, 25, 25, 1),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              // Firebase 적용 사항
                              Text(
                                '자세히',
                                style: TextStyle(
                                    color: const Color.fromRGBO(0, 0, 0, 1),
                                    fontSize: size.width * 0.036,
                                    fontWeight: FontWeight.normal,
                                    height: 1.2),
                              ),
                              SizedBox(width: size.width * 0.03),
                              Icon(Icons.keyboard_arrow_right_sharp,
                                  size: size.width * 0.05, color: Colors.black)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

// 종목카드를 모은 리스트
  Widget Cardlist(Size size, List<Map<String, dynamic>> stocklist) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        itemCount: stocklist.length,
        itemBuilder: (BuildContext context, int index) {
          return Stockcard(
              context,
              size,
              stocklist[index]['stockName'],
              stocklist[index]['stockPrice'],
              stocklist[index]['stockChange'],
              stocklist[index]['stockPerChange'],
              stocklist[index]['stockVolume'],
              stocklist[index]['marketCap'],
              stocklist[index]['stockCode']);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: mainPageAppBar(
        context,
        "관심 종목",
        SettingButton(context),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: customFuture(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Map<String, dynamic>> stockcardlist = snapshot.data ?? [];
            if (stockcardlist.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      color: GREY,
                      size: size.height * 0.1,
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    Text(
                      "관심 종목이 없습니다.",
                      style: TextStyle(
                        fontSize: size.width * 0.07,
                        color: GREY,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Column(
                children: [
                  Cardlist(size, stockcardlist),
                ],
              );
            }
          } else {
            return Center(child: indicator());
          }
        },
      ),
    );
  }
}
