import 'dart:async';

import 'package:flutter/material.dart';

class MarqueeWidget extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new  MarqueeWidgetState();
  }
}

class MarqueeWidgetState extends State<MarqueeWidget> with SingleTickerProviderStateMixin{

  ScrollController scroController;
  double screenWidth;
  double positiom=0.0;
  Timer timer;
  String text="ListView即滚动列表控件，能将子控件组成可滚动的列表。当你需要排列的子控件超出容器大小";
  List<Widget> widgets=new List();

  @override
  void initState() {
    super.initState();
    scroController=new ScrollController();
    timer=Timer.periodic(new Duration(milliseconds: 100), (timer){
      double maxScrollExtent=scroController.position.maxScrollExtent;
      double pixels=scroController.position.pixels;
      if(pixels+3.0>=maxScrollExtent){
        positiom=(maxScrollExtent-screenWidth/4+screenWidth)/2-screenWidth+pixels-maxScrollExtent;
        scroController.jumpTo(positiom);
      }
      positiom+=3.0;
      scroController.animateTo(positiom,duration: new Duration(milliseconds: 90),curve: Curves.linear);
    });
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenWidth=MediaQuery.of(context).size.width;
    widgets.add(new Text(text,style: new TextStyle(fontSize: 16.0)));
    widgets.add(new Container(width: screenWidth/4));
    widgets.add(new Text(text,style: new TextStyle(fontSize: 16.0)));
  }


  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("跑马灯"),
      ),
      body: new ListView(
        scrollDirection: Axis.horizontal,
        controller: scroController,
        physics: new NeverScrollableScrollPhysics(),
        children: <Widget>[
          widgets[0],
          widgets[1],
          widgets[2],
        ],
      ),
    );
  }
}