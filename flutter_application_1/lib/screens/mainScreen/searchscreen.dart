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
      body: Container(
        height: size.height,
        width: size.width,
        child: buildFloatingSearchBar(context, size),
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
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Material(
            color: Colors.white,
            elevation: 4,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('stock_API2')
                    .where("stockName", isGreaterThanOrEqualTo: selectedTerm)
                    .where("stockName",
                        isLessThanOrEqualTo: selectedTerm + "\uF7FF")
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
                        increaseList.add(snapshot.data.docs[i].data()
                            as Map<String, dynamic>);
                      }
                      return searchStockList(size, increaseList);
                    }
                    // return _buildList(context, snapshot.data);
                  }
                }),
          ),
        );
      },
    );
  }

  // Widget _buildList(BuildContext context, List<Map<String, dynamic>> data) {
  //   for (DocumentSnapshot d in snapshot) {
  //     searchResults.add(d);
  //   }

  //   return Expanded(
  //     child: GridView.count(
  //       crossAxisSpacing: 1,
  //       mainAxisSpacing: 2,
  //       crossAxisCount: 2,
  //       children: <Widget>[],
  //     ),
  //   );
  // }
}

// builder: (context) {
//                 return SingleChildScrollView(
//                   child: SizedBox(
//                     height: size.height,
//                     width: size.width,
//                     child: ListView.separated(
//                       itemCount: increaseList.length,
//                       separatorBuilder: (BuildContext context, int index) =>
//                           const Divider(color: GREY),
//                       itemBuilder: (BuildContext context, int index) {
//                         setState(() {
//                           selectedTerm = controller!.query;
//                           print(increaseList.length);
//                         });
//                         return Text(increaseList[index]["stockName"]);
//                       },
//                     ),
//                   ),
//                 );
//               },

// Widget Searchbar(Size size) {
//   return Container(
//       width: size.width * 0.9,
//       height: size.height * 0.04,
//       margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(10),
//           topRight: Radius.circular(10),
//           bottomLeft: Radius.circular(10),
//           bottomRight: Radius.circular(10),
//         ),
//       ),
//       child: Row(children: [
//         Container(
//             margin: EdgeInsets.only(left: size.width * 0.9 * 0.02),
//             child: SvgPicture.asset('assets/icons/search.svg',
//                 semanticsLabel: 'search')),

//         // Firebase 적용 사항
//         // 입력 시 입력한 string이 포함되는 종목이 노출되도록해야함
//         Expanded(
//           child: Autocomplete<Stock>(
// // optionBuilder : 현재 텍스트에 따라 표시할 옵션 목록을 필터링할 수 있다.
//             optionsBuilder: (TextEditingValue textEditingValue) {
//               return countryOptions
//                   .where((Stock county) => county.name
//                       .toLowerCase()
//                       .startsWith(textEditingValue.text.toLowerCase()))
//                   .toList();
//             },

// // Returns the string to display in the field when the option is selected.
// // 옵션을 클릭했을 때 검색바에 나오는 옵션
//             displayStringForOption: (Stock option) => option.name,

// // 검색바 스타일
//             fieldViewBuilder: (BuildContext context,
//                 TextEditingController fieldTextEditingController,
//                 FocusNode fieldFocusNode,
//                 VoidCallback onFieldSubmitted) {
//               return TextField(
//                 controller: fieldTextEditingController,
//                 focusNode: fieldFocusNode,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                 ),
//               );
//             },

// //옵션 선택 시
//             onSelected: (Stock selection) {
//               print('Selected: ${selection.name}');
//             },

// // 검색 시 아래 자동완성 뷰
//             optionsViewBuilder: (BuildContext context,
//                 AutocompleteOnSelected<Stock> onSelected,
//                 Iterable<Stock> options) {
//               return Align(
//                 alignment: Alignment.topLeft,
//                 child: Material(
//                   child: Container(
//                     width: 300,
//                     color: Colors.cyan,
//                     child: ListView.builder(
//                       padding: EdgeInsets.all(10.0),
//                       itemCount: options.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         final Stock option = options.elementAt(index);
//                         return GestureDetector(
//                           onTap: () {
//                             onSelected(option);
//                           },
//                           child: ListTile(
//                             title: Text(option.name,
//                                 style: const TextStyle(color: Colors.white)),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         )
//       ]));
// }
