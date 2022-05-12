import 'dart:io';
import 'package:flutter_application_1/splashPage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => SplashPage(),
      },
      theme: ThemeData(fontFamily: 'nanum'),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaleFactor: Platform.isIOS ? 1 : 0.8,
        ),
        child: child!,
      ),
    );
  }
}
