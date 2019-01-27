import 'package:flutter/material.dart';
import 'package:flutterapp/components/drawablestarttext.dart';

class DrawableStartTextDemo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("DrawableStartText"),
      ),
      body: new Center(
        child: new Container(
          child: new DrawableStartText(
            assetImage: "images/tianmao.jpg",
            text: " 莫顿 全自动感应壁挂式酒精喷雾式手消毒器 手消毒机杀菌净手器",
            textStyle: new TextStyle(fontSize: 17.0),
          ),
        ),
      ),
    );
  }
}


