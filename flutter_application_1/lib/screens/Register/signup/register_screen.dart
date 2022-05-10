// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Animation/fade_animation.dart';
import 'package:flutter_application_1/screens/Register/function.dart';
import 'package:flutter_application_1/screens/Register/registerComponents.dart';
import 'package:flutter_application_1/tool/validator.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  FocusNode _focus = FocusNode();
  final _emailKey = GlobalKey<FormState>();
  final _nameKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  var _email = "";
  var _nickname = "";
  var _password = "";

  Widget informaion(Size size) {
    return Container(
      padding: EdgeInsets.only(left: size.width * 0.1),
      margin: EdgeInsets.only(bottom: size.height * 0.05),
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
                "단타충 ",
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                "계정",
                style: TextStyle(
                  color: Color(0xff0039A4),
                ),
              ),
              Text(
                "을 만들고 주식 뉴스를 쉽게 확인하세요!",
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
      key: _emailKey,
      child: Center(
        child: SizedBox(
          height: size.height * 0.1,
          width: size.width * 0.8,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
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
              if (_emailKey.currentState != null) {
                _emailKey.currentState!.validate();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget nickNameInput(Size size) {
    return Form(
      key: _nameKey,
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
              _nickname = value;
              if (_nameKey.currentState != null) {
                _nameKey.currentState!.validate();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget passwordInput(Size size) {
    return Form(
      key: _passwordKey,
      child: Center(
        child: SizedBox(
          height: size.height * 0.1,
          width: size.width * 0.8,
          child: TextFormField(
            obscureText: true,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(size.height * 0.02),
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff0039A4)),
                    borderRadius: BorderRadius.circular(10)),
                hintText: "ㆍㆍㆍㆍㆍㆍㆍㆍ",
                hintStyle: TextStyle(color: Colors.grey[400])),
            validator: (value) =>
                CheckValidate().validatePassword(_focus, value!),
            onChanged: (value) {
              _password = value;
              if (_passwordKey.currentState != null) {
                _passwordKey.currentState!.validate();
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
            if (_emailKey.currentState!.validate() &&
                _passwordKey.currentState!.validate()) {
              await signUpWithEmail(_email, _password, context);
            } else {
              _emailKey.currentState!.validate();
              _passwordKey.currentState!.validate();
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
        child: Center(
          child: SingleChildScrollView(
            child: FadeAnimation(
              2,
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  informaion(size),
                  decoText(size, "이메일"),
                  emailInput(size),
                  decoText(size, "비밀번호"),
                  passwordInput(size),
                  registerButton(size),
                  SizedBox(height: size.height * 0.05),
                  alreadyLoginButton(context, size),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
