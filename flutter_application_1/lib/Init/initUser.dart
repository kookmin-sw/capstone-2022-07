// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/indicator.dart';
import 'package:flutter_application_1/screens/Register/function.dart';
import 'package:flutter_application_1/screens/Register/login_screen.dart';
import 'package:flutter_application_1/screens/Register/signup/input_nickname_screen.dart';
import 'package:flutter_application_1/screens/Register/signup/verify_screen.dart';
import 'package:flutter_application_1/screens/mainScreen/start_screen.dart';

class InitUser extends StatelessWidget {
  const InitUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (!snapshot.hasData) {
          return LoginScreen();
        } else {
          return FutureBuilder(
            future: findNickname(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data) {
                  return StartScreen();
                } else {
                  if (!FirebaseAuth.instance.currentUser!.emailVerified) {
                    return VerifyScreen();
                  } else {
                    return InputNicknameScreen();
                  }
                }
              } else {
                return Container(
                  color: Colors.white,
                  child: Center(
                    child: indicator(),
                  ),
                );
              }
            },
          );
        }
      },
    );
  }
}
