// ignore_for_file: unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:badges/badges.dart';

class Navbar extends StatefulWidget {
  Navbar({Key? key}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int selectedIndex = 0;
  int badge = 0;
  final padding = EdgeInsets.symmetric(horizontal: 18, vertical: 12);
  double gap = 10;

  PageController controller = PageController();

  List<Color> colors = [
    Colors.purple,
    Colors.pink,
    Colors.amber[600]!,
    Colors.teal
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;
    int badge = 0;
    final padding = EdgeInsets.symmetric(horizontal: 18, vertical: 12);
    double gap = 10;

    return SafeArea(
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
              )
            ],
            selectedIndex: selectedIndex,
            onTabChange: (index) {
              setState(() {
                selectedIndex = index;
              });
              // controller.jumpToPage(index);
            },
          ),
        ),
      ),
    );
  }
}
