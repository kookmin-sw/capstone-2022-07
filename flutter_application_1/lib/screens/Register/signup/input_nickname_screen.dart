// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_final_fields, unused_field

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Animation/fade_animation.dart';
import 'package:flutter_application_1/screens/Register/function.dart';
import 'package:flutter_application_1/screens/Register/registerComponents.dart';
import 'package:flutter_application_1/tool/validator.dart';

class InputNicknameScreen extends StatefulWidget {
  InputNicknameScreen({Key? key}) : super(key: key);

  @override
  State<InputNicknameScreen> createState() => _InputNicknameScreenState();
}

class _InputNicknameScreenState extends State<InputNicknameScreen> {
  FocusNode _focus = FocusNode();
  final _nickNameKey = GlobalKey<FormState>();
  var _nickName = "";

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
              "회원가입",
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
                "사용하실 ",
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                "닉네임",
                style: TextStyle(
                  color: Color(0xff0039A4),
                ),
              ),
              Text(
                "을 입력해주세요!",
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

  Widget nickNameInput(Size size) {
    return Form(
      key: _nickNameKey,
      child: Center(
        child: SizedBox(
          height: size.height * 0.1,
          width: size.width * 0.8,
          child: TextFormField(
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(size.height * 0.02),
                prefixIcon: Icon(Icons.people),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]!),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff0039A4)),
                    borderRadius: BorderRadius.circular(10)),
                hintText: "이름",
                hintStyle: TextStyle(color: Colors.grey[400])),
            validator: (value) =>
                CheckValidate().validateNickname(_focus, value!),
            onChanged: (value) {
              _nickName = value;
              if (_nickNameKey.currentState != null) {
                _nickNameKey.currentState!.validate();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget registerButton(Size size) {
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
          onPressed: () async {
            if (_nickNameKey.currentState!.validate()) {
              await updateNickname(_nickName);
              authStateChanges(context);
            }
          },
          child: Text(
            "회원가입",
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
                decoText(size, "닉네임"),
                nickNameInput(size),
                registerButton(size),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
