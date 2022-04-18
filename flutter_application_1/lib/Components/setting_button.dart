// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/Register/function.dart';

IconButton SettingButton(BuildContext context) {
  return IconButton(
    onPressed: () {
      // Navigator.pop(context);
      signOut(context);
    },
    icon: Icon(Icons.settings),
    color: Colors.black,
  );
}
