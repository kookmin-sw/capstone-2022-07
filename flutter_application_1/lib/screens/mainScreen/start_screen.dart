// ignore_for_file: prefer_const_constructors_in_immutables, prefer_final_fields, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/willPop.dart';
import 'package:flutter_application_1/Controller/notification_details_page_controller.dart';
import 'package:flutter_application_1/screens/mainScreen/interestsscreen.dart';
import 'package:flutter_application_1/screens/mainScreen/mainscreen.dart';
import 'package:flutter_application_1/screens/mainScreen/searchscreen.dart';
import 'package:flutter_application_1/screens/mainScreen/profilescreen.dart';
import 'package:get/get.dart';
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
    Profilescreen()
  ];

  int selectedIndex = 0;
  int badge = 0;
  final padding = EdgeInsets.symmetric(horizontal: 18, vertical: 12);
  double gap = 10;

  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool result = onWillPop();
        return await Future.value(result);
      },
      child: Scaffold(
        body: _widgetOptions.elementAt(selectedIndex),
        bottomNavigationBar: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3),
              child: GNav(
                tabs: [
                  GButton(
                    gap: gap,
                    iconActiveColor: Color(0xff0039A4),
                    iconColor: Colors.black,
                    textColor: Color(0xff0039A4),
                    backgroundColor: Color(0xff0039A4).withOpacity(.2),
                    iconSize: 24,
                    padding: padding,
                    icon: Icons.home,
                    text: 'Home',
                  ),
                  GButton(
                    gap: gap,
                    iconActiveColor: Color(0xff0039A4),
                    iconColor: Colors.black,
                    textColor: Color(0xff0039A4),
                    backgroundColor: Color(0xff0039A4).withOpacity(.2),
                    iconSize: 24,
                    padding: padding,
                    icon: Icons.favorite,
                    leading: selectedIndex == 1 || badge == 0
                        ? null
                        : Badge(
                            badgeColor: Color(0xff0039A4),
                            elevation: 0,
                            position: BadgePosition.topEnd(top: -12, end: -12),
                            badgeContent: Text(
                              badge.toString(),
                              style: TextStyle(color: Color(0xff0039A4)),
                            ),
                            child: Icon(
                              Icons.favorite,
                              color: selectedIndex == 1
                                  ? Color(0xff0039A4)
                                  : Colors.black,
                            ),
                          ),
                    text: 'Likes',
                  ),
                  GButton(
                    gap: gap,
                    iconActiveColor: Color(0xff0039A4),
                    iconColor: Colors.black,
                    textColor: Color(0xff0039A4),
                    backgroundColor: Color(0xff0039A4).withOpacity(.2),
                    iconSize: 24,
                    padding: padding,
                    icon: Icons.search,
                    text: 'Search',
                  ),
                  GButton(
                    gap: gap,
                    iconActiveColor: Color(0xff0039A4),
                    iconColor: Colors.black,
                    textColor: Color(0xff0039A4),
                    backgroundColor: Color(0xff0039A4).withOpacity(.2),
                    iconSize: 24,
                    padding: padding,
                    icon: Icons.person,
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
      ),
    );
  }
}
