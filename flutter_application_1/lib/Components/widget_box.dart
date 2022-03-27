// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

BoxDecoration widgetBoxDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(8),
      topRight: Radius.circular(8),
      bottomLeft: Radius.circular(8),
      bottomRight: Radius.circular(8),
    ),
    boxShadow: [
      BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.25),
          offset: Offset(0, 4),
          blurRadius: 4)
    ],
    color: Color.fromRGBO(255, 255, 255, 1),
  );
}
