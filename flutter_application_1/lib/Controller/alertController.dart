// ignore_for_file: prefer_const_constructors

import 'package:flutter_application_1/screens/mainScreen/notification_details_page.dart';
import 'package:flutter_application_1/screens/mainScreen/start_screen.dart';
import 'package:flutter_application_1/screens/mainScreen/stockscreen.dart';
import 'package:flutter_application_1/splashPage.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AlertController extends GetxController {
  static AlertController get to => Get.find();
  final Rxn<RemoteMessage> remoteMessage = Rxn<RemoteMessage>();

  Future<bool> initialize() async {
    String? token = await FirebaseMessaging.instance.getToken();
    try {
      print(token);
    } catch (e) {}

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    const AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(
      'high_importance_channel', // 임의의 id
      'High Importance Notifications', // 설정에 보일 채널명
      description:
          'This channel is used for important notifications.', // 설정에 보일 채널 설명
      importance: Importance.max,
    );

    // Notification Channel을 디바이스에 생성
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);

    await flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/launcher_icon'),
            iOS: IOSInitializationSettings()),
        onSelectNotification: (String? payload) async {});

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      remoteMessage.value = message;
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              androidNotificationChannel
                  .id, // AndroidNotificationChannel()에서 생성한 ID
              androidNotificationChannel.name,
              channelDescription: androidNotificationChannel.description,
            ),
          ),
          payload: message.data['argument'],
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage rm) async {
      if (rm.data['screen'] == 'Stockscreen') {
        await Get.to(() => SplashPage());
        if (FirebaseAuth.instance.currentUser != null) {
          Get.to(() => Stockscreen(
              stockName: rm.data["stockName"],
              stockCode: rm.data["stockCode"]));
        }
      }
    });

    // Terminated 상태에서 도착한 메시지에 대한 처리
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print(initialMessage.data['screen']);
      if (initialMessage.data['screen'] == 'Stockscreen') {
        Get.to(() => Stockscreen(
            stockName: initialMessage.data["stockName"],
            stockCode: initialMessage.data["stockCode"]));
      } else {
        Get.to(() => StartScreen(), arguments: initialMessage.data['argument']);
      }
    }

    return true;
  }
}
