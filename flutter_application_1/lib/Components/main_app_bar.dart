// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Components/setting_button.dart';

AppBar mainAppBar(BuildContext context, String title) {
  return AppBar(
    systemOverlayStyle: SystemUiOverlayStyle(),
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(color: Colors.black),
    ),
    leading: BackButton(
      color: Colors.black,
      onPressed: () {},
    ),
    actions: [SettingButton(context)],
    leadingWidth: 70,
    backgroundColor: Colors.transparent,
    elevation: 0.0,
  );
}
