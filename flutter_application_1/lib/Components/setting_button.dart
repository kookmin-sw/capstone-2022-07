// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';

IconButton SettingButton(BuildContext context) {
  return IconButton(
    onPressed: () {
      // Navigator.pop(context);
    },
    icon: Icon(Icons.settings),
    color: Colors.black,
  );
}
