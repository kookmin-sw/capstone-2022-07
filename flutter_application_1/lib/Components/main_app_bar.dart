// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Components/star_button.dart';

AppBar mainAppBar(
    BuildContext context, String title, IconButton button, Size size) {
  return AppBar(
    systemOverlayStyle: SystemUiOverlayStyle(),
    title: Image.asset(
      'assets/logos/logo_text.png',
      width: size.width * 0.4,
      // height: size.height * 0.3,
    ),
    centerTitle: true,
    actions: [button],
    leadingWidth: 70,
    backgroundColor: Colors.transparent,
    elevation: 0.0,
  );
}

AppBar mainPageAppBar(BuildContext context, String title, IconButton button) {
  return AppBar(
    systemOverlayStyle: SystemUiOverlayStyle(),
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(color: Colors.black),
    ),
    actions: [button],
    leadingWidth: 70,
    backgroundColor: Colors.transparent,
    elevation: 0.0,
  );
}

AppBar noneActionAppBar(BuildContext context, String title) {
  return AppBar(
    systemOverlayStyle: SystemUiOverlayStyle(),
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(color: Colors.black),
    ),
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
    ),
    leadingWidth: 70,
    backgroundColor: Colors.transparent,
    elevation: 0.0,
  );
}

AppBar StockscreenBar(
    BuildContext context, String title, String stockName, String stockCode) {
  return AppBar(
    systemOverlayStyle: SystemUiOverlayStyle(),
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(color: Colors.black),
    ),
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
    ),
    actions: [FavoriteButton(stockName, stockCode)],
    leadingWidth: 70,
    backgroundColor: Colors.transparent,
    elevation: 0.0,
  );
}
