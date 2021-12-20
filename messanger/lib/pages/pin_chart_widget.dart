import 'package:flutter/material.dart';
import 'package:flutter_arduino/api.dart';
import 'package:flutter_arduino/model/data.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PinChart extends StatefulWidget {
  final List<PinsData> data;

  PinChart({required this.data});

  @override
  _PinChartState createState() => _PinChartState();
}

class _PinChartState extends State<PinChart> {
  bool ledOn = true;
  @override
  Widget build(BuildContext context) {
    List<charts.Series<PinsData, String>> series = [
      charts.Series(
        id: "developers",
        data: widget.data,
        domainFn: (PinsData series, _) => series.name,
        measureFn: (PinsData series, _) => series.value,
        colorFn: (PinsData series, _) => series.barColor,
      ),
    ];

    return Container(
      padding: EdgeInsets.all(10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Column(
            children: <Widget>[
              Text(
                "ESP8266 Pin Status",
              ),
              Expanded(
                child: charts.BarChart(series, animate: true),
              ),
              Container(
                  child: Switch(
                onChanged: (value) {
                  setState(
                    () {
                      ledOn = !ledOn;
                    },
                  );
                  API.toggleLED(value);
                },
                value: ledOn,
                activeColor: Colors.cyan,
                // activeTrackColor: Colors.yellow,
                inactiveThumbColor: Colors.redAccent,
                inactiveTrackColor: Colors.orange,
              ))
            ],
          ),
        ),
      ),
    );
  }
}
