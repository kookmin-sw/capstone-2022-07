// ignore_for_file: prefer_const_constructors, prefer_final_fields, prefer_const_constructors_in_immutables, unused_field

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Animation/fade_animation.dart';
import 'package:flutter_application_1/screens/Register/registerComponents.dart';
import 'package:flutter_application_1/screens/Register/signin/find_password_input_email_screen.dart';
import 'package:flutter_application_1/tool/validator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_1/screens/Register/function.dart';

class SigninScreen extends StatefulWidget {
  SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  FocusNode _focus = FocusNode();
  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  var _email = "";
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
              "로그인",
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
                "지금 ",
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                "로그인",
                style: TextStyle(
                  color: Color(0xff0039A4),
                ),
              ),
              Text(
                "하여 주식 뉴스를 쉽게 확인하세요!",
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

  Widget forgetPasswordButton(Size size) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return FindPasswordInputEmailScreen();
            },
          ),
        );
      },
      child: Text(
        "비밀번호를 잊으셨나요?",
        style: TextStyle(
          fontSize: size.width * 0.03,
          color: Color(0xff0039A4),
        ),
      ),
    );
  }

  Widget loginButton(Size size) {
    return Center(
      child: Container(
        height: size.height * 0.06,
        width: size.width * 0.8,
        margin: EdgeInsets.only(
            top: size.height * 0.02, bottom: size.height * 0.05),
        decoration: BoxDecoration(
          color: Color(0xff0039A4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton(
          onPressed: () {
            if (_emailKey.currentState!.validate() &&
                _passwordKey.currentState!.validate()) {
              signInWithEmail(_email, _password, context);
            } else {
              _emailKey.currentState!.validate();
              _passwordKey.currentState!.validate();
            }
          },
          child: Text(
            "로그인",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.035,
                color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget devide(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: size.width * 0.05),
          width: size.height * 0.12,
          child: Divider(
            color: Colors.grey[400],
            thickness: 0.8,
          ),
        ),
        Text(
          "간편 로그인",
          style: TextStyle(color: Colors.grey[400]),
        ),
        Container(
          margin: EdgeInsets.only(left: size.width * 0.05),
          width: size.height * 0.12,
          child: Divider(
            color: Colors.grey[400],
            thickness: 0.8,
          ),
        ),
      ],
    );
  }

  Widget googleLoginButton(BuildContext context, Size size) {
    return Center(
      child: Container(
        height: size.height * 0.06,
        width: size.width * 0.8,
        margin: EdgeInsets.only(
            top: size.height * 0.05, bottom: size.height * 0.01),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black),
        ),
        child: TextButton(
          onPressed: () async {
            await signInWithGoogle(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/logos/google_logo.svg',
                width: size.width * 0.1,
                height: size.height * 0.03,
              ),
              SizedBox(
                width: size.width * 0.02,
              ),
              Text("구글 계정으로 로그인",
                  style: TextStyle(
                      fontSize: size.width * 0.035, color: Colors.black)),
            ],
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
                  Row(
                    children: [
                      decoText(size, "비밀번호"),
                      forgetPasswordButton(size),
                    ],
                  ),
                  passwordInput(size),
                  loginButton(size),
                  devide(size),
                  googleLoginButton(context, size),
                  SizedBox(
                    height: size.height * 0.05,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
