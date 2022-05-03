// // Copyright 2018 The Flutter team. All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.
//
// //ignore_for_file:, non_constant_identifier_names, prefer_const_constructors_in_immutables
//
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Components/main_app_bar.dart';
// import 'package:flutter_application_1/Components/setting_button.dart';
// import 'package:flutter_application_1/Components/stockcard.dart';
//
// class Recentscreen extends StatefulWidget {
//   Recentscreen({Key? key}) : super(key: key);
//
//   @override
//   State<Recentscreen> createState() => _RecentscreenState();
// }
//
// class _RecentscreenState extends State<Recentscreen> {
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: mainAppBar(
//         context,
//         "최근 조회 종목",
//         SettingButton(context),
//       ),
//       body: Column(
//         children: [
//           Cardlist(size, st),
//         ],
//       ),
//     );
//   }
// }
