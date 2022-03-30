import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void initState() {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;
  late ZoomPanBehavior _zoompan;

  data = [
    _ChartData('CHN', 12),
    _ChartData('GER', 15),
    _ChartData('RUS', 30),
    _ChartData('BRZ', 6.4),
    _ChartData('IND', 14)
  ];
  _tooltip = TooltipBehavior(enable: true);
  _zoompan = ZoomPanBehavior(
    enableDoubleTapZooming: true,
    enableMouseWheelZooming: true,
  );
  super.initState();
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
