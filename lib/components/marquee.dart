import 'dart:async';

import 'package:flutter/material.dart';


class MarqueeWidget extends StatefulWidget{

  final String text;
  final TextStyle textStyle;
  final Axis scrollAxis;
  final double ratioOfBlankToScreen;
  final double width;
  final double height;

  MarqueeWidget({
    @required this.text,
    this.textStyle,
    this.scrollAxis:Axis.horizontal,
    this.ratioOfBlankToScreen:0.25,
    this.width,
    this.height
  }) :assert(text!=null,);

  @override
  State<StatefulWidget> createState() {
    return new  MarqueeWidgetState();
  }
}

class MarqueeWidgetState extends State<MarqueeWidget> with SingleTickerProviderStateMixin{

  ScrollController scroController;
  double screenWidth;
  double screenHeight;
  double position=0.0;
  Timer timer;
  List<Widget> widgets=new List();

  @override
  void initState() {
    super.initState();
    scroController=new ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((callback){
      startTimer();
    });
  }

  void startTimer(){
    timer=Timer.periodic(new Duration(milliseconds: 100), (timer){
      double maxScrollExtent=scroController.position.maxScrollExtent;
      double pixels=scroController.position.pixels;
      if(pixels+3.0>=maxScrollExtent){
        position=(maxScrollExtent-screenWidth/4+screenWidth)/2-screenWidth+pixels-maxScrollExtent;
        scroController.jumpTo(position);
      }
      position+=3.0;
      scroController.animateTo(position,duration: new Duration(milliseconds: 90),curve: Curves.linear);
    });
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenWidth=MediaQuery.of(context).size.width;
    screenHeight=MediaQuery.of(context).size.height;
  }

  Widget getBothEndsChild(){
    if(widget.scrollAxis ==Axis.vertical){
      String newString=widget.text.split("").join("\n");
      return new Text(newString,style: widget.textStyle,textAlign: TextAlign.center,);
    }
    return new Text(widget.text,style: widget.textStyle,);
  }

  Widget getCenterChild(){
    if(widget.scrollAxis ==Axis.horizontal){
      return new Container(width: screenWidth*widget.ratioOfBlankToScreen);
    }else{
      return new Container(height: screenHeight*widget.ratioOfBlankToScreen);
    }
  }



  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double containerWidth=new Text(widget.text,style: widget.textStyle).style.fontSize;
    return new Container(
      width: widget.width!=null&&widget.width>containerWidth?widget.width:containerWidth,
      height: widget.height==null?null: widget.height,
      child: new Center(
        child: new ListView(
          scrollDirection: widget.scrollAxis,
          controller: scroController,
          physics: new NeverScrollableScrollPhysics(),
          children: <Widget>[
            getBothEndsChild(),
            getCenterChild(),
            getBothEndsChild(),
          ],
        ),
      ),
    );
  }
}