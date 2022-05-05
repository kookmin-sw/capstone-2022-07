import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

DateTime? currentBackPressTime;

onWillPop() {
  DateTime now = DateTime.now();
  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
    currentBackPressTime = now;
    Fluttertoast.showToast(
        msg: "'뒤로' 버튼을 한번 더 누르시면 종료됩니다.",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xff6E6E6E),
        // fontSize: 20,
        toastLength: Toast.LENGTH_LONG);
    return false;
  }
  return true;
}
