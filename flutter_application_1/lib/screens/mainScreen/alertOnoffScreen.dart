// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/Color/color.dart';
import 'package:flutter_application_1/Components/main_app_bar.dart';
import 'package:flutter_application_1/Components/setting_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getwidget/getwidget.dart';

class AlertOnoffScreen extends StatefulWidget {
  AlertOnoffScreen({Key? key}) : super(key: key);

  @override
  State<AlertOnoffScreen> createState() => _AlertOnoffScreenState();
}

class _AlertOnoffScreenState extends State<AlertOnoffScreen> {
  bool allAlarm = true;
  bool interestAlarm = false;
  late List<bool> isSelected;

  @override
  void initState() {
    isSelected = [allAlarm, interestAlarm];
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
                onChanged: (value) {
                  setState(() {
                    allAlarm = value;
                    if (allAlarm == false) {
                      interestAlarm = false;
                    }
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
                onChanged: (value) {
                  setState(
                    () {
                      if (!allAlarm) {
                        interestAlarm = false;
                      } else {
                        interestAlarm = value;
                      }
                    },
                  );
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
      body: Column(
        children: [
          allAlarmTogle(size),
          Container(
            color: Colors.white,
            child: Divider(),
          ),
          interestAlarmTogle(size),
        ],
      ),
    );
  }
}
