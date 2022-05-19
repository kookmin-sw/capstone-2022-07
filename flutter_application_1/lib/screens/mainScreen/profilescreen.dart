// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/indicator.dart';
import 'package:flutter_application_1/Components/setting_button.dart';
import 'package:flutter_application_1/screens/Register/function.dart';
import 'package:flutter_application_1/Components/main_app_bar.dart';
import 'package:flutter_application_1/Color/Color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/mainScreen/alertOnoffScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter_application_1/screens/Register/login_screen.dart';
import 'package:get/get.dart';

class Profilescreen extends StatefulWidget {
  Profilescreen({Key? key}) : super(key: key);
  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  Future<Map<String, dynamic>> _getuserdata() async {
    String useruid = await FirebaseAuth.instance.currentUser!.uid;
    var finduser = await FirebaseFirestore.instance
        .collection('users')
        .where("uid", isEqualTo: useruid)
        .get();
    Map<String, dynamic> userdata = finduser.docs[0].data();
    return userdata;
  }

  Widget profileimgandnickname(size, data) {
    String nickname = data['nickname'];
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.05),
      color: Color.fromRGBO(249, 249, 249, 1),
      height: size.height * 0.35,
      width: size.width * 0.9,
      child: Column(
        children: [
          Image.asset('assets/icons/user.png', width: size.height * 0.2),
          SizedBox(
            height: size.height * 0.03,
          ),
          Text(
            nickname,
            style: GoogleFonts.notoSans(fontSize: size.width * 0.05),
          ),
        ],
      ),
    );
  }

  Widget profilealarm(size) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return AlertOnoffScreen();
            },
          ),
        );
      },
      child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey, offset: Offset(0, 1), blurRadius: 1)
              ],
              color: Colors.white),
          padding: EdgeInsets.only(left: size.width * 0.04),
          width: size.width * 0.8,
          height: size.height * 0.07,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.notifications_none, color: CHART_MINUS),
                  SizedBox(width: size.width * 0.04),
                  Text(
                    '알람 설정',
                    style: GoogleFonts.notoSans(fontSize: size.width * 0.04),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(right: size.width * 0.05),
                child: Icon(Icons.arrow_forward_ios),
              )
            ],
          )),
    );
  }

  Widget profilelogout(size) {
    return InkWell(
      child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey, offset: Offset(0, 1), blurRadius: 1)
              ],
              color: Colors.white),
          padding: EdgeInsets.only(left: size.width * 0.04),
          width: size.width * 0.8,
          height: size.height * 0.07,
          child: Row(
            children: [
              Icon(Icons.logout, color: CHART_MINUS),
              SizedBox(width: size.width * 0.04),
              Text(
                '로그아웃',
                style: GoogleFonts.notoSans(fontSize: size.width * 0.04),
              )
            ],
          )),
      onTap: () async {
        print("Log out");
        signOut(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => LoginScreen()));
      },
    );
  }

  Widget SettingPage(context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<Map<String, dynamic>>(
        future: _getuserdata(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          Map<String, dynamic>? data = snapshot.data;
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                width: size.width * 0.9,
                height: size.height * 0.7,
                child: Column(
                  children: [
                    profileimgandnickname(size, data),
                    profilealarm(size),
                    SizedBox(height: size.height * 0.01),
                    profilelogout(size),
                  ],
                ));
          } else {
            return Center(child: indicator());
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    _getuserdata();
    return Scaffold(
      appBar: mainPageAppBar(
        context,
        "프로필",
      ),
      body: SettingPage(context),
    );
  }
}
