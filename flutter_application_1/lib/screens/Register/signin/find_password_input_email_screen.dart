// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Animation/fade_animation.dart';
import 'package:flutter_application_1/screens/Register/function.dart';
import 'package:flutter_application_1/screens/Register/registerComponents.dart';
import 'package:flutter_application_1/screens/Register/signin/find_password_verify_screen.dart';
import 'package:flutter_application_1/tool/validator.dart';

class FindPasswordInputEmailScreen extends StatefulWidget {
  FindPasswordInputEmailScreen({Key? key}) : super(key: key);

  @override
  State<FindPasswordInputEmailScreen> createState() =>
      _FindPasswordInputEmailScreenState();
}

class _FindPasswordInputEmailScreenState
    extends State<FindPasswordInputEmailScreen> {
  FocusNode _focus = FocusNode();
  final _findEmailKey = GlobalKey<FormState>();
  // ignore: unused_field
  var _email = "";

  Widget informaion(Size size) {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.1),
      padding: EdgeInsets.only(left: size.width * 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: size.height * 0.02),
            child: Text(
              "비밀번호를 잊으셨나요?",
              style: TextStyle(
                color: Color(0xff0039A4),
                fontSize: size.width * 0.07,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              Text(
                "인증을 통해 ",
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                "비밀번호",
                style: TextStyle(
                  color: Color(0xff0039A4),
                ),
              ),
              Text(
                "를 복구해 드리겠습니다.",
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget emailInput(Size size) {
    return Form(
      key: _findEmailKey,
      child: Center(
        child: SizedBox(
          height: size.height * 0.1,
          width: size.width * 0.8,
          child: TextFormField(
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(size.height * 0.02),
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]!),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff0039A4)),
                    borderRadius: BorderRadius.circular(10)),
                hintText: "abc@example.com",
                hintStyle: TextStyle(color: Colors.grey[400])),
            validator: (value) => CheckValidate().validateEmail(_focus, value!),
            onChanged: (value) {
              _email = value;
              if (_findEmailKey.currentState != null) {
                _findEmailKey.currentState!.validate();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget confirmButton(Size size) {
    return Center(
      child: Container(
        height: size.height * 0.06,
        width: size.width * 0.8,
        margin: EdgeInsets.only(top: size.height * 0.02),
        decoration: BoxDecoration(
          color: Color(0xff0039A4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton(
          onPressed: () {
            if (_findEmailKey.currentState!.validate()) {
              resetPassword(_email);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return FindPasswordVerifyScreen();
                  },
                ),
              );
            }
          },
          child: Text(
            "확인",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.035,
                color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(),
        leading: BackButton(
          color: Colors.black,
        ),
        leadingWidth: 70,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: FadeAnimation(
            2,
            Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                informaion(size),
                SizedBox(height: size.height * 0.05),
                decoText(size, "이메일"),
                emailInput(size),
                confirmButton(size),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
