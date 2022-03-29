// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

BoxDecoration widgetBoxDecoration(
    double radius,               // 테두리 경계선
    int boxshadowcolor,       // 테두리 색
    double boxshadowblur,        // 테두리 흐림 정도
    int boxcolor              // 박스 색
    )
{
  return BoxDecoration(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
      bottomLeft: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
    ),
    boxShadow: [
      BoxShadow(
          color: Color.fromRGBO(boxshadowcolor, boxshadowcolor, boxshadowcolor, 0.25),
          offset: Offset(0, 4),
          blurRadius: boxshadowblur)
    ],
    color: Color.fromRGBO(boxcolor, boxcolor, boxcolor, 1),
  );
}
