// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Color/Color.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FavoriteButton extends StatefulWidget implements PreferredSizeWidget {
  FavoriteButton(this.stockName, this.stockCode)
      : preferredSize = Size.fromHeight(60.0),
        super();
  final Size preferredSize;
  final String stockName;
  final String stockCode;

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool IsFavorite;
  Future Isstockfavorite() async {
    var user = await FirebaseFirestore.instance
        .collection('users')
        .doc(await FirebaseAuth.instance.currentUser!.uid)
        .get();
    List<dynamic> favoritelist = user['favorite'];
    if (favoritelist.contains(widget.stockName)) {
      IsFavorite = true;
    } else {
      IsFavorite = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData favorite;
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: Isstockfavorite(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (IsFavorite == true) {
              favorite = Icons.star;
            } else {
              favorite = Icons.star_outline;
            }
            return GestureDetector(
              onTap: () async {
                print(widget.stockCode);
                setState(() {
                  IsFavorite = !IsFavorite;
                });
                if (IsFavorite == false) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({
                    "favorite": FieldValue.arrayRemove([widget.stockName])
                  });
                  await FirebaseMessaging.instance
                      .unsubscribeFromTopic(widget.stockCode);
                } else {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({
                    "favorite": FieldValue.arrayUnion([widget.stockName])
                  });

                  await FirebaseMessaging.instance
                      .subscribeToTopic(widget.stockCode);
                }
              },
              child: Container(
                margin: EdgeInsets.only(right: size.width * 0.05),
                child: Icon(
                  favorite,
                  color: CHART_MINUS,
                ),
              ),
            );
          } else {
            return Container(
              margin: EdgeInsets.only(right: size.width * 0.05),
              child: Icon(
                Icons.star_border,
                color: CHART_MINUS,
              ),
            );
          }
        });
  }
}
