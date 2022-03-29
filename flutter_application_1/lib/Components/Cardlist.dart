// ignore_for_file: prefer_const_literals_to_create_immutables, unnecessary_const, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/Color/Color.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_1/Components/widget_box.dart';

//view용 임시 리스트
final List<String> Name = <String>[
  '삼성전자',
  '이승중견기업',
  '동국산업',
  'LG에너지솔루션',
  '빵꾸똥꾸'
];
final List<int> Price = <int>[79900, 999999900, 12350, 379900, 12321];
final List<String> Perc = <String>[
  '-2.49%',
  '+1.49%',
  '+3.49%',
  '-5.12%',
  '+30%'
];
final List<int> Volume = <int>[265232, 52802, 1232, 25232, 1557];


//종목을 카드로 나타냄
Widget Stockcard(Size size, var name, var price, var perc, var volume) {
  var color;
  if (perc[0] == '+') {
    color = CHART_PLUS;
  } else {
    color = CHART_MINUS;
  }
  var intl = NumberFormat.currency(locale: "ko_KR", symbol: "￦");

  price = intl.format(price);
  volume = intl.format(volume);

  return Container(
    height: size.height * 0.18,
    width: size.width * 0.9,
    decoration: widgetBoxDecoration(8,255,4,255),
    padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.03, vertical: size.height * 0.01),
    margin: EdgeInsets.only(bottom: size.height * 0.03),
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: size.height * 0.01),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: EdgeInsets.only(right: size.width * 0.03),
                child: SvgPicture.asset('assets/icons/vectorcheckbox.svg',
                    semanticsLabel: 'vectorcheckbox'),
              ),
              Expanded(
                child: Text(
                  name,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Content',
                    fontSize: 18,
                    letterSpacing: 0,
                    fontWeight: FontWeight.normal,
                    height: 1,
                  ),
                ),
              ),
              SvgPicture.asset('assets/icons/vectorcross.svg',
                  semanticsLabel: 'vectorcross'),
            ],
          ),
        ),
        Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: size.width * 0.01, top: size.height * 0.02),
              child: Row(
                children: [
                  Container(
                    decoration: widgetBoxDecoration(4, 255, 4, 249),
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.03,
                        vertical: size.height * 0.01),
                    child: Text(
                      '주가 : $price',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: color,
                        fontFamily: 'Content',
                        fontSize: 12,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1,
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.03),
                  Container(
                    decoration: widgetBoxDecoration(4, 255, 4, 249),
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.03,
                        vertical: size.height * 0.01),
                    child: Text(
                      '대비(등락) : $perc',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: color,
                        fontFamily: 'Content',
                        fontSize: 12,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Container(
              padding: EdgeInsets.only(left: size.width * 0.01),
              child: Row(
                children: [
                  Container(
                    decoration: widgetBoxDecoration(4, 255, 4, 249),
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.03,
                        vertical: size.height * 0.01),
                    child: Text(
                      '거래량 : $volume',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: color,
                        fontFamily: 'Content',
                        fontSize: 12,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.03,
                          vertical: size.height * 0.005),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: const Radius.circular(16),
                          bottomRight: const Radius.circular(16),
                        ),
                        color: const Color.fromRGBO(249, 249, 249, 1),
                        boxShadow: [
                          const BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.25),
                              offset: Offset(0, 4),
                              blurRadius: 4)
                        ],
                        border: Border.all(
                          color: const Color.fromRGBO(25, 25, 25, 1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            '자세히',
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'ABeeZee',
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                height: 1.2),
                          ),
                          SizedBox(width: size.width * 0.03),
                          SvgPicture.asset(
                              'assets/images/vectorstroketoright.svg',
                              semanticsLabel: 'vectorstroketoright')
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    ),
  );
}

// 종목카드를 모은 리스트
Widget CardList(Size size) {
  return Expanded(
    child: ListView.builder(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      itemCount: Name.length,
      itemBuilder: (BuildContext context, int index) {
        return Stockcard(size, Name[index], Price[index], Perc[index],
            Volume[index]);
      },
    ),
  );
}

