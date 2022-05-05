// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Controller/notification_details_page_controller.dart';
import 'package:flutter_application_1/screens/mainScreen/start_screen.dart';
import 'package:get/get.dart';

// Push Notification 을 터치했을 때 이동할 페이지
class NotificationDetailsPage
    extends GetView<NotificationDetailsPageController> {
  const NotificationDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(NotificationDetailsPageController());
    return StartScreen();
  }
}
