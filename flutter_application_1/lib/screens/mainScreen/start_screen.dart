// ignore_for_file: prefer_const_constructors_in_immutables, prefer_final_fields, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/mainScreen/interestsscreen.dart';
import 'package:flutter_application_1/screens/mainScreen/mainscreen.dart';
import 'package:flutter_application_1/screens/mainScreen/searchscreen.dart';
import 'package:flutter_application_1/screens/mainScreen/stockscreen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:badges/badges.dart';

class StartScreen extends StatefulWidget {
  StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  List<Widget> _widgetOptions = <Widget>[
    Mainscreen(),
    InterestScreen(),
    Searchscreen(),
    Stockscreen(
      stockName: "동국산업",
    ),
  ];

  int selectedIndex = 0;
  int badge = 0;
  final padding = EdgeInsets.symmetric(horizontal: 18, vertical: 12);
  double gap = 10;

  PageController controller = PageController();

  List<Color> colors = [
    Colors.purple,
    Colors.pink,
    Colors.amber[600]!,
    Colors.teal,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _widgetOptions.elementAt(selectedIndex),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(100)),
            boxShadow: [
              BoxShadow(
                spreadRadius: -10,
                blurRadius: 60,
                color: Colors.black.withOpacity(.4),
                offset: Offset(0, 25),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3),
            child: GNav(
              tabs: [
                GButton(
                  gap: gap,
                  iconActiveColor: Colors.purple,
                  iconColor: Colors.black,
                  textColor: Colors.purple,
                  backgroundColor: Colors.purple.withOpacity(.2),
                  iconSize: 24,
                  padding: padding,
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  gap: gap,
                  iconActiveColor: Colors.pink,
                  iconColor: Colors.black,
                  textColor: Colors.pink,
                  backgroundColor: Colors.pink.withOpacity(.2),
                  iconSize: 24,
                  padding: padding,
                  icon: Icons.favorite,
                  leading: selectedIndex == 1 || badge == 0
                      ? null
                      : Badge(
                          badgeColor: Colors.red.shade100,
                          elevation: 0,
                          position: BadgePosition.topEnd(top: -12, end: -12),
                          badgeContent: Text(
                            badge.toString(),
                            style: TextStyle(color: Colors.red.shade900),
                          ),
                          child: Icon(
                            Icons.favorite,
                            color:
                                selectedIndex == 1 ? Colors.pink : Colors.black,
                          ),
                        ),
                  text: 'Likes',
                ),
                GButton(
                  gap: gap,
                  iconActiveColor: Colors.amber[600],
                  iconColor: Colors.black,
                  textColor: Colors.amber[600],
                  backgroundColor: Colors.amber[600]!.withOpacity(.2),
                  iconSize: 24,
                  padding: padding,
                  icon: Icons.search,
                  text: 'Search',
                ),
                GButton(
                  gap: gap,
                  iconActiveColor: Colors.teal,
                  iconColor: Colors.black,
                  textColor: Colors.teal,
                  backgroundColor: Colors.teal.withOpacity(.2),
                  iconSize: 24,
                  padding: padding,
                  icon: Icons.supervised_user_circle,
                  // leading: CircleAvatar(
                  //   radius: 12,
                  //   // backgroundImage: NetworkImage(
                  //   //   'https://sooxt98.space/content/images/size/w100/2019/01/profile.png',
                  //   // ),
                  // ),
                  text: 'User',
                ),
              ],
              selectedIndex: selectedIndex,
              onTabChange: (index) {
                setState(() {
                  selectedIndex = index;
                  print(selectedIndex);
                });
                // controller.jumpToPage(index);
              },
            ),
          ),
        ),
      ),
    );
  }
}
