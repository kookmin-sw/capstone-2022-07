// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/mainScreen/interestsscreen.dart';
import 'package:flutter_application_1/screens/mainScreen/mainscreen.dart';
import 'package:flutter_application_1/screens/mainScreen/stockscreen.dart';

class Init extends StatelessWidget {
  const Init({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (!snapshot.hasData) {
          return Stockscreen();
        }
        return LoginScreen();
      },
    );
  }
}
