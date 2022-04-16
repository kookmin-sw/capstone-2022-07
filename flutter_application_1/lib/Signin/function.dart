// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/signup/input_nickname_screen.dart';
import 'package:flutter_application_1/screens/start_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<UserCredential> signInWithGoogle() async {
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
  return await FirebaseAuth.instance.signInWithCredential(credential);
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

void authStateChanges(BuildContext context) async {
  await FirebaseAuth.instance.currentUser!.reload();
  Map<String, dynamic> firebaseUserdata = {};
  User firebaseUser = FirebaseAuth.instance.currentUser!;
  if (firebaseUser != null) {
    firebaseUserdata = await findUserByUid(firebaseUser.uid);
    print(firebaseUserdata);
    if (firebaseUserdata != null) {
      updateLoginTime();
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
      await saveUserToFirebase();
    }
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
  };
  return firebaseUserdata;
}

Future<void> saveUserToFirebase() async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  users.add(await fromMap(FirebaseAuth.instance.currentUser!));
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
  users.doc(docId).update({'nickname': nickname});
}
