// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/setting_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_1/Components/main_app_bar.dart';
import 'package:flutter_application_1/Color/color.dart';
import 'package:flutter_application_1/Components/stock_list.dart';
class Searchscreen extends StatefulWidget {
  Searchscreen({Key? key}) : super(key: key);
  @override
  State<Searchscreen> createState() => _SearchscreenState();
}


class _SearchscreenState extends State<Searchscreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: mainAppBar(
        context,
        "검색",
        SettingButton(context),
      ),
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.1,
          ),
          Searchbar(size),
        ],
      )

    );
  }
}

Widget Searchbar(Size size) {
  return Container(
    width: size.width * 0.9,
    height: size.height * 0.04,
    margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      ),
      color: Color.fromRGBO(224, 228, 233, 1)

    ),
      child: Row(
        children: [
          Container(
              margin: EdgeInsets.only(left: size.width * 0.9 * 0.02),
              child: SvgPicture.asset('assets/icons/search.svg',
                  semanticsLabel: 'search')),
          
          // Firebase 적용 사항
          // 입력 시 입력한 string이 포함되는 종목이 노출되도록해야함 
          Expanded(
            child:
            Autocomplete<Stock>(
// optionBuilder : 현재 텍스트에 따라 표시할 옵션 목록을 필터링할 수 있다.
              optionsBuilder: (TextEditingValue textEditingValue) {
                return countryOptions
                    .where((Stock county) => county.name.toLowerCase()
                    .startsWith(textEditingValue.text.toLowerCase())
                )
                    .toList();
              },

// Returns the string to display in the field when the option is selected.
// 옵션을 클릭했을 때 검색바에 나오는 옵션
              displayStringForOption: (Stock option) => option.name,

// 검색바 스타일
              fieldViewBuilder: (              BuildContext context,
                  TextEditingController fieldTextEditingController,
                  FocusNode fieldFocusNode,
                  VoidCallback onFieldSubmitted
                  ) {

                return TextField(
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  style: const TextStyle(fontWeight: FontWeight.bold,

                  ),
                );
              },

//옵션 선택 시
              onSelected: (Stock selection) {
                print('Selected: ${selection.name}');
              },

// 검색 시 아래 자동완성 뷰
              optionsViewBuilder: (
                  BuildContext context,
                  AutocompleteOnSelected<Stock> onSelected,
                  Iterable<Stock> options
                  ) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    child: Container(
                      width: 300,
                      color: Colors.cyan,
                      child: ListView.builder(
                        padding: EdgeInsets.all(10.0),
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Stock option = options.elementAt(index);

                          return GestureDetector(
                            onTap: () {
                              onSelected(option);
                            },
                            child: ListTile(
                              title: Text(option.name, style: const TextStyle(color: Colors.white)),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ]
      )
  );
}
