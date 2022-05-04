// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Controller/alertController.dart';
import 'package:flutter_application_1/Init/initUser.dart';
import 'package:get/get.dart';

class InitAlert extends StatelessWidget {
  InitAlert({Key? key}) : super(key: key);
  final AlertController controller = Get.put(AlertController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.initialize(), // 여기서 앱 실행 전에 해야 하는 초기화 진행
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            home: InitUser(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          );
        }
      },
    );
  }
}
