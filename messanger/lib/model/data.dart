import 'package:flutter/material.dart';
import 'package:flutter_arduino/api.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PinsData {
  final String name;
  final double value;
  final charts.Color barColor = charts.ColorUtil.fromDartColor(Colors.cyan);

  PinsData({
    required this.name,
    required this.value,
  });

  static Future<List<PinsData>> getData() async {
    List<dynamic> pinList = await API.getPinsStatus();
    List<PinsData> pinDataList = [];
    for (int i = 0; i < pinList.length; i++) {
      pinDataList.add(PinsData(name: 'D' + i.toString(), value: pinList[i]));
    }
    return pinDataList;
  }
}
