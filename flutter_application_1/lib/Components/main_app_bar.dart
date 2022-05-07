// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

AppBar mainAppBar(BuildContext context, String title, IconButton button) {
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


