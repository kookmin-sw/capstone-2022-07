// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'dart:async';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Color/color.dart';
import 'package:flutter_application_1/Components/indicator.dart';
import 'package:flutter_application_1/Components/main_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class AlertOnoffScreen extends StatefulWidget {
  AlertOnoffScreen({Key? key}) : super(key: key);

  @override
  State<AlertOnoffScreen> createState() => _AlertOnoffScreenState();
}

class _AlertOnoffScreenState extends State<AlertOnoffScreen> {
  Map<String, dynamic> firebaseUserdata = {};
  late Future getUserData;
  late bool allAlarm;
  late bool interestAlarm;

  Future findUserByUid(String uid) => AsyncMemoizer().runOnce(
        () async {
          CollectionReference users =
              FirebaseFirestore.instance.collection('users');
          QuerySnapshot data = await users.where('uid', isEqualTo: uid).get();

          firebaseUserdata = data.docs[0].data() as Map<String, dynamic>;
          allAlarm = firebaseUserdata["allNotification"];
          interestAlarm = firebaseUserdata["interestNotification"];

          if (data.size == 0) {
            return null;
          } else {
            return data.docs[0].data();
          }
        },
      );

  @override
  void initState() {
    getUserData = findUserByUid(FirebaseAuth.instance.currentUser!.uid);
    super.initState();
  }

  Widget allAlarmTogle(size) {
    return Container(
        margin: EdgeInsets.only(top: size.height * 0.02),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            color: Colors.white),
        padding: EdgeInsets.only(left: size.width * 0.04),
        width: size.width,
        height: size.height * 0.07,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.notifications_none, color: CHART_MINUS),
                SizedBox(width: size.width * 0.04),
                Text(
                  '전체 알람 설정',
                  style: GoogleFonts.notoSans(
                      fontSize: size.width * 0.04,
                      textStyle: TextStyle(color: Colors.black)),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(right: size.width * 0.05),
              child: CupertinoSwitch(
                activeColor: CHART_MINUS,
                value: allAlarm,
                onChanged: (value) async {
                  setState(() {
                    allAlarm = value;
                    if (allAlarm == false) {
                      interestAlarm = false;
                    }
                  });
                  if (allAlarm == false) {
                    await FirebaseMessaging.instance
                        .unsubscribeFromTopic("All");
                  } else {
                    await FirebaseMessaging.instance.subscribeToTopic("All");
                  }
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({
                    "allNotification": allAlarm,
                    "interestNotification": interestAlarm,
                  });
                },
              ),
            )
          ],
        ));
  }

  Widget interestAlarmTogle(size) {
    return Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            color: Colors.white),
        padding: EdgeInsets.only(left: size.width * 0.04),
        width: size.width,
        height: size.height * 0.07,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.star,
                    color: allAlarm ? CHART_MINUS : Colors.grey[300]),
                SizedBox(width: size.width * 0.04),
                Text(
                  '관심 종목 알람 설정',
                  style: GoogleFonts.notoSans(
                      fontSize: size.width * 0.04,
                      textStyle: TextStyle(
                          color: allAlarm ? Colors.black : Colors.grey[300])),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(right: size.width * 0.05),
              child: CupertinoSwitch(
                activeColor: CHART_MINUS,
                value: interestAlarm,
                onChanged: (value) async {
                  setState(
                    () {
                      if (!allAlarm) {
                        interestAlarm = false;
                      } else {
                        interestAlarm = value;
                      }
                    },
                  );
                  if (interestAlarm) {
                    await FirebaseMessaging.instance
                        .subscribeToTopic("interest");
                  } else {
                    await FirebaseMessaging.instance
                        .unsubscribeFromTopic("interest");
                  }
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({"interestNotification": interestAlarm});
                },
              ),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: noneActionAppBar(
        context,
        "푸시 알림 설정",
      ),
      body: FutureBuilder(
          future: getUserData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              firebaseUserdata = snapshot.data as Map<String, dynamic>;
              return Column(
                children: [
                  allAlarmTogle(size),
                  Container(
                    color: Colors.white,
                    child: Divider(),
                  ),
                  interestAlarmTogle(size),
                ],
              );
            } else {
              return Center(
                child: indicator(),
              );
            }
          }),
    );
  }
}
