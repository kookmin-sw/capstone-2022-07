// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_const_literals_to_create_immutables, non_constant_identifier_names, prefer_const_constructors_in_immutables, constant_identifier_names, prefer_typing_uninitialized_variables, unnecessary_string_interpolations, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/main_app_bar.dart';
import 'package:flutter_application_1/Components/setting_button.dart';
import 'package:flutter_application_1/Components/stockcard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/Register/function.dart';

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
          .collection('stock_API2')
          .where("stockName", isEqualTo: "${element}")
          .get();
      stockdata = userstockinfo.docs[0].data();
      stockcardlist.add(stockdata);
    }

    return stockcardlist;
  }

  Future<List<Map<String, dynamic>>> customFuture() async {
    var userstockinfo = await _getstockList();
    var stockinfo = await _getstockInfo(userstockinfo);
    return stockinfo;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: customFuture(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Map<String, dynamic>> stockcardlist = snapshot.data ?? [];
            return Scaffold(
              appBar: mainPageAppBar(
                context,
                "관심 종목",
                SettingButton(context),
              ),
              body: Column(
                children: [
                  Cardlist(size, stockcardlist),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
