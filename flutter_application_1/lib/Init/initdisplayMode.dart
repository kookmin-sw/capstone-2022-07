// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Init/initAlert.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

class InitDisplayMode extends StatelessWidget {
  const InitDisplayMode({Key? key}) : super(key: key);

  Future<bool> initialize() async {
    final List<DisplayMode> supported = await FlutterDisplayMode.supported;
    final DisplayMode active = await FlutterDisplayMode.active;

    final List<DisplayMode> sameResolution = supported
        .where((DisplayMode m) =>
            m.width == active.width && m.height == active.height)
        .toList()
      ..sort((DisplayMode a, DisplayMode b) =>
          b.refreshRate.compareTo(a.refreshRate));

    final DisplayMode mostOptimalMode =
        sameResolution.isNotEmpty ? sameResolution.first : active;

    /// This setting is per session.
    /// Please ensure this was placed with `initState` of your root widget.
    await FlutterDisplayMode.setPreferredMode(mostOptimalMode);

    return true;
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initialize(), // 여기서 앱 실행 전에 해야 하는 초기화 진행
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return InitAlert();
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
