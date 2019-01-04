import 'package:flutter/material.dart';
import 'package:flutterapp/components/radarchart.dart';

class RadarChartDemo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("雷达图"),
      ),
      body: new Center(
        child: new RadarChart(),
      ),
    );
  }

}