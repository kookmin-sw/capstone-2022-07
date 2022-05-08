// ignore_for_file: import_of_legacy_library_into_null_safe, prefer_const_constructors, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/Register/signup/input_nickname_screen.dart';
import 'package:flutter_application_1/screens/Register/signup/register_screen.dart';
import 'package:flutter_application_1/screens/Register/signup/verify_screen.dart';
import 'package:flutter_application_1/screens/Register/login_screen.dart';
import 'package:flutter_application_1/screens/mainScreen/start_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> signInWithGoogle(BuildContext context) async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  await FirebaseAuth.instance.signInWithCredential(credential);

  if (FirebaseAuth.instance.currentUser != null) {
    authStateChanges(context);
  }
}

Future signUpWithEmail(String id, String password, BuildContext context) async {
  try {
    UserCredential credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: id, password: password);
    if (credential.user != null) {
      await credential.user!.sendEmailVerification();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return VerifyScreen();
          },
        ),
      );
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('이미 사용중인 이메일입니다.'),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return RegisterScreen();
          },
        ),
      );
    }
  } catch (e) {
    print(e);
  }
}

Future<dynamic> signInWithEmail(
    String id, String password, BuildContext context) async {
  try {
    UserCredential credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: id, password: password);

    if (credential != null) {
      authStateChanges(context);
      return true;
    } else {
      return false;
    }
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'invalid-email':
        {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('잘못된 이메일입니다.'),
            ),
          );
          return false;
        }
      case 'user-not-found':
        {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('사용자가 존재하지 않습니다.'),
            ),
          );
          return false;
        }
      case 'wrong-password':
        {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('비밀번호가 잘못되었습니다.'),
            ),
          );
          return false;
        }
      default:
        {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('오류가 발생하였습니다. 다시 시도해 주세요.'),
            ),
          );
          return false;
        }
    }
  }
}

Future<void> resetPassword(String email) async {
  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
}

Future findUserByUid(String uid) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  QuerySnapshot data = await users.where('uid', isEqualTo: uid).get();

  if (data.size == 0) {
    return null;
  } else {
    return data.docs[0].data();
  }
}

Future<void> authStateChanges(BuildContext context) async {
  await FirebaseAuth.instance.currentUser!.reload();
  Map<String, dynamic> firebaseUserdata = {};
  if (FirebaseAuth.instance.currentUser != null) {
    User firebaseUser = FirebaseAuth.instance.currentUser!;
    firebaseUserdata = await findUserByUid(firebaseUser.uid);
    print(firebaseUserdata);
    if (firebaseUserdata != null) {
      if (firebaseUserdata.isNotEmpty) {
        updateLoginTime();
        if (firebaseUser.emailVerified) {
          if (await firebaseUserdata['nickname'] == "") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return InputNicknameScreen();
                },
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return StartScreen();
                },
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('이메일 인증이 완료되지 않았습니다.'),
            ),
          );
        }
      } else {
        await saveUserToFirebase();
      }
    } else {
      await saveUserToFirebase();
    }
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LoginScreen();
        },
      ),
    );
  }
}

Future<Map<String, dynamic>> fromMap(User firebaseUser) async {
  Map<String, dynamic> firebaseUserdata = {};
  String deviceToken = "";
  await FirebaseMessaging.instance
      .getToken()
      .then((value) => deviceToken = value!);
  firebaseUserdata = {
    'uid': FirebaseAuth.instance.currentUser!.uid,
    'email': FirebaseAuth.instance.currentUser!.email,
    'nickname': "",
    'createdAt': DateTime.now().toLocal(),
    'lastLogin': DateTime.now().toLocal(),
    "deviceToken": deviceToken,
    'status': true,
    "favorite": [],
    "visited": [],
  };
  return firebaseUserdata;
}

Future<void> saveUserToFirebase() async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  users
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .set(await fromMap(FirebaseAuth.instance.currentUser!));
}

void updateLoginTime() async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  QuerySnapshot data = await users
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get();
  String deviceToken = "";

  await FirebaseMessaging.instance
      .getToken()
      .then((value) => deviceToken = value!);
  users.doc(data.docs[0].id).update({
    'lastLogin': DateTime.now().toLocal(),
    'deviceToken': deviceToken,
  });
}

Future<void> updateNickname(String nickname) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  QuerySnapshot data = await users
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get();
  String docId = data.docs[0].id;
  await users.doc(docId).update({'nickname': nickname});
}

Future<bool> findNickname() async {
  Map<String, dynamic> firebaseUserdata = {};
  firebaseUserdata =
      await findUserByUid(FirebaseAuth.instance.currentUser!.uid);

  if (firebaseUserdata != null) {
    if (firebaseUserdata.isNotEmpty) {
      if (firebaseUserdata['nickname'] != "") {
        return true;
      } else {
        return false;
      }
    }
  }
  return false;
}

Future signOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => (LoginScreen())),
      (route) => false);
}
