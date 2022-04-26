import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/Register/signin/signin_screen.dart';

Widget decoText(Size size, String text) {
  return Container(
    padding: EdgeInsets.only(
        top: size.height * 0.01,
        left: size.width * 0.1,
        bottom: size.height * 0.01),
    child: Text(text),
  );
}

Widget alreadyLoginButton(BuildContext context, Size size) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "이미 계정이 있으신가요?",
        style: TextStyle(fontSize: size.width * 0.03, color: Colors.grey[600]),
      ),
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return SigninScreen();
              },
            ),
          );
        },
        child: Text(
          "로그인",
          style: TextStyle(
              fontSize: size.width * 0.03,
              decoration: TextDecoration.underline,
              color: Color(0xff0039A4),
              fontWeight: FontWeight.bold),
        ),
      )
    ],
  );
}
