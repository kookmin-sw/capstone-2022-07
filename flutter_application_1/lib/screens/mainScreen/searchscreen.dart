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
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: size.height * 0.1,
              child: Container(
                  width: size.width * 0.9,
                  height: size.height * 0.1,
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
                  child: Container(
                      // alignment: Alignment.center,
                      child: Center(child: Text("Test용 Container")))),
            ),
            buildFloatingSearchBar(context, size),
          ],
        ),
      ),
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
            selectedTerm = query;
          },
        );
      },
      builder: (context, transition) {
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('stock_API2')
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
