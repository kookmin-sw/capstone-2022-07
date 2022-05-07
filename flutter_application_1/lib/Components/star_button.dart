// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Color/Color.dart';
class StockScreenAppBar extends StatefulWidget implements PreferredSizeWidget {

  StockScreenAppBar(this.stockName) : preferredSize = Size.fromHeight(60.0), super();
  final Size preferredSize;
  final String stockName;

  @override
  _StockScreenAppBarState createState() => _StockScreenAppBarState();
}


class _StockScreenAppBarState extends State<StockScreenAppBar> {
  late bool IsFavorite;
  Future Isstockfavorite() async {
    var user = await FirebaseFirestore.instance.collection('users')
        .doc(await FirebaseAuth.instance.currentUser!.uid).get();
    List<dynamic> favoritelist = user['favorite'];
    if(favoritelist.contains(widget.stockName)){
      IsFavorite = true;
    }else{
      IsFavorite = false;
    }
  }
  GestureDetector FavoriteButton(BuildContext context) {
    IconData favorite;
    if(IsFavorite == true){
      favorite = Icons.star;
    }else{
      favorite = Icons.star_outline;
    }
    return GestureDetector(

      onTap: () async {
        setState(() {
          IsFavorite = !IsFavorite;

        });
        if (IsFavorite == false) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth
              .instance.currentUser!.uid)
              .update({
            "favorite": FieldValue.arrayRemove(
                [widget.stockName])
          });
        } else {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth
              .instance.currentUser!.uid)
              .update({
            "favorite": FieldValue.arrayUnion(
                [widget.stockName])
          });
        }
      },
      child : Icon(
        favorite,
        color : CHART_MINUS,
      ),

    );
  }
  @override
  Widget build(BuildContext context) {
    IconData favorite;
    return FutureBuilder(
    future: Isstockfavorite(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if(snapshot.connectionState== ConnectionState.done){
        return AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(),
          centerTitle: true,
          title: Text(
            "종목 정보",
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          actions: [FavoriteButton(context)],
          leadingWidth: 70,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        );
      }else{
        return AppBar();
      }
    }
    );


  }
}