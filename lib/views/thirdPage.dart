import 'package:flutter/material.dart';

class ThirdPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new ThirdPageState();
  }

}

class ThirdPageState extends State<ThirdPage>{

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("界面3"),),
      body: new Center(child: new Text("这是第三个界面"),),
    );
  }
}