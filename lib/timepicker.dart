import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class Timepicker extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new TimepickerState();
  }

}

class TimepickerState extends State<Timepicker> with SingleTickerProviderStateMixin{

  List<String> hours;
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(duration: const Duration(milliseconds: 1800), vsync: this);
    hours=new List();
    for(int i=0;i<24;i++){
      hours.add(i.toString()+"小时");
    }
  }


  double start=0.0;
  double offset=0.0;
  TextPaintCanvas paintCanvas;
  FrictionSimulation frictionSimulation;
  AnimationStatusListener statusListener;
  VoidCallback voidCallback;
  int downTime;


  @override
  Widget build(BuildContext context) {
    return  new Scaffold(
      backgroundColor: Colors.white70,
      appBar: new AppBar(
        title: new Text("时间选择器"),
      ),
      body: new Builder(builder: (BuildContext contextx){
        return new Center(
          child:new Container(
            width: 80.0,
            height: 130.0,
            child: new GestureDetector(
                onVerticalDragDown: (getureDragDownCallback){
                  if(!controller.isCompleted) {
                    paintCanvas.changeFirstCount();
                    animation.removeListener(voidCallback);
                    animation.removeStatusListener(statusListener);
                    controller.reset();
                  }
                },
                onVerticalDragStart: (getureDragStartCallback){
                  downTime=DateTime.now().millisecondsSinceEpoch;
                  start=getureDragStartCallback.globalPosition.dy;
                },
                /******************************************************************************************************************/
                onVerticalDragEnd: (getureDragEndCallback){
                  Velocity velo=getureDragEndCallback.velocity;
                  if(velo.pixelsPerSecond.dy.isNaN){
                    return;
                  }
                  double lastOffset=offset;
                  double distance=(velo.pixelsPerSecond.dy).abs()/10;
                  if(DateTime.now().millisecondsSinceEpoch-downTime<300&&lastOffset<15&&distance==0.0){
                    return;
                  }
                  double controlOffset = paintCanvas.getOffset(distance + lastOffset.abs());
                  if(controlOffset.isNaN){
                    return;
                  }
                  if(distance==0.0){
                    distance=paintCanvas.getItemHeight()-controlOffset;
                  }


                  double scrollOffset;
                  if(velo.pixelsPerSecond.dy==0.0){
                    frictionSimulation=new FrictionSimulation.through(0.0,distance+0.1,20.0,0.0);
                    scrollOffset=frictionSimulation.timeAtX(distance);
                  }else{
                    frictionSimulation=new FrictionSimulation.through(0.0,distance,20.0,0.0);
                    scrollOffset=frictionSimulation.timeAtX(distance-controlOffset);
                  }


                  animation = new Tween(begin: 0.0, end: scrollOffset).animate(controller);
                  voidCallback=(){
                    if(animation.value==0.0){
                      return;
                    }
                    if(offset<0){
                      offset=-(frictionSimulation.x(animation.value))+lastOffset;
                    }else{
                      offset=frictionSimulation.x(animation.value)+lastOffset;
                    }
                    if(offset.isNaN){
                      return;
                    }
                    setState(() {
                      paintCanvas.changeDatas(offset,hours);
                    });
                  };
                  statusListener=(animationStatus){
                    if(animationStatus==AnimationStatus.completed){
                      //offset=0.0;
                      paintCanvas.changeFirstCount();
                      animation.removeListener(voidCallback);
                      animation.removeStatusListener(statusListener);
                      controller.reset();
                      Scaffold.of(contextx).showSnackBar(new SnackBar(content: new Text(hours[3]),duration: new Duration(seconds: 1),));
                    }else if(animationStatus==AnimationStatus.forward){
                      //frictionSimulation.x(430.0);
                    }
                  };
                  animation.addStatusListener(statusListener);
                  animation.addListener(voidCallback);
                  controller.forward();
                },
                /******************************************************************************************************************/
                onVerticalDragUpdate: (getureDragUpdateCallback){
                  double point =getureDragUpdateCallback.globalPosition.dy;
                  offset=start-point;
                  if(offset.abs()<15){
                    return;
                  }
                  setState(() {
                    paintCanvas.changeDatas(offset,hours);
                  });
                },
                onVerticalDragCancel: (){

                },
                child: new CustomPaint(
                  painter: paintCanvas=new TextPaintCanvas(-offset,hours),
                )
            ),
          ),
        );
      }),
    );
  }
}

class TextPaintCanvas extends CustomPainter{

  TextPaintCanvas(this.offset,this.hours);

  double offset;
  static double maginsHeight=0.0;
  static double smallTextHright=0.0;
  static int firstCount=0;
  List<String> hours;
  static double preOffset=0.0;
  static int modle=0;


  void changeFirstCount(){
    firstCount=0;
    preOffset=0.0;
    firstCount=0;
    modle=0;
  }

  double getOffset(double lastOffset){
    if(maginsHeight!=0.0) {
      return lastOffset % (smallTextHright + maginsHeight);
    }
    return 0.0;
  }

  double getItemHeight(){
    if(maginsHeight!=0.0) {
      return smallTextHright + maginsHeight;
    }
    return 0.0;
  }

  void changeDatas(double offsets,List<String> hours){
    if(maginsHeight!=0.0) {
      int a = offsets ~/ (smallTextHright + maginsHeight);
      if (firstCount != a) {
        //向上滑
        if (preOffset-offsets<0) {
          //移除第一个，加到末尾
          if(getOffset(offsets)==0.0){
            return;
          }
          String first = hours.first;
          hours.removeAt(0);
          hours.add(first);
          firstCount ++;
          preOffset=offsets;
          //向下滑
        } else if (preOffset-offsets>0) {
          //除去最后一个。加到前面
          String last = hours.last;
          hours.removeLast();
          hours.insert(0, last);
          firstCount --;
          preOffset=offsets;
        }
      }else if(firstCount == a&&firstCount==0){
        if(offsets>0&&modle!=1){
          modle=1;
          String first = hours.first;
          hours.removeAt(0);
          hours.add(first);
        }else if(offsets<0&&modle!=-1){
          modle=-1;
          String last = hours.last;
          hours.removeLast();
          hours.insert(0, last);
        }
      }
    }
  }

  void parseOffset(){
    if(maginsHeight!=0.0) {
      offset = offset % (smallTextHright + maginsHeight);
      //print(offset);
    }
  }


  double getRadian(double itemOffset,double controlHeight,double maginsHeight,double smallTextHright){
    double radian;
    double radius=controlHeight/2+smallTextHright+maginsHeight;
    if(itemOffset<controlHeight/2){
      //上半圈距中心的距离
      double offHeight=controlHeight/2-itemOffset;
      radian=asin(offHeight/radius);
    }else if(itemOffset>controlHeight/2){
      double offHeight=itemOffset-controlHeight/2+smallTextHright;
      radian=-asin(offHeight/radius);
    }else if(itemOffset==controlHeight/2){
      radian=0.0;
    }
    print(radian);
    return radian;
  }

  void drawText(Canvas canvas,TextPainter painterSmall,double itemOffset,String texts){
    canvas.save();
    canvas.translate(0.0, itemOffset);
    painterSmall.text=new TextSpan(text: texts,style: new TextStyle(fontSize: 18.0,color: Colors.black));
    painterSmall.layout();
    if(smallTextHright==0.0){
      smallTextHright=painterSmall.size.height;
    }
    double smallTextWidth=painterSmall.size.width;
    //计算间距
    if(maginsHeight==0.0){
      maginsHeight=(130.0-smallTextHright*5.0)/4;
    }
    try {
      canvas.transform(Matrix4.rotationX(getRadian(itemOffset, 130.0, maginsHeight, smallTextHright)).storage);
    }catch(e){

    }
    painterSmall.paint(canvas, new Offset((80-smallTextWidth)/2, 0.0));
    canvas.restore();
  }



  @override
  void paint(Canvas canvas, Size size) {
    parseOffset();
    canvas.clipRect(new Rect.fromLTRB(0.0, 0.0, 80.0, 130.0));

    TextPainter painterSmall=new TextPainter();
    painterSmall.textDirection=TextDirection.ltr;
    painterSmall.maxLines=1;

    //第一条Item,初始化不可见
    drawText(canvas,painterSmall,-maginsHeight-smallTextHright+offset,hours[0]);
    //第二条Item
    drawText(canvas,painterSmall,offset,hours[1]);
    //第三条Item
    drawText(canvas,painterSmall,maginsHeight+smallTextHright+offset,hours[2]);
    //最中间的Item
    drawText(canvas,painterSmall,maginsHeight*2+smallTextHright*2+offset,hours[3]);
    //第五条Item
    drawText(canvas,painterSmall,maginsHeight*3+smallTextHright*3+offset,hours[4]);
    //第六条Item
    drawText(canvas,painterSmall,maginsHeight*4+smallTextHright*4+offset,hours[5]);
    //第七条Item
    drawText(canvas,painterSmall,maginsHeight*5+smallTextHright*5+offset,hours[6]);

    Rect rect=Rect.fromLTRB(0.0, 0.0, 80.0, maginsHeight*2+smallTextHright*2);
    Paint paintRext=new Paint();
    paintRext.color=Color(0x90ffffff);
    canvas.drawRect(rect, paintRext);

    canvas.translate(0.0, maginsHeight*2+smallTextHright*3);
    rect=Rect.fromLTRB(0.0, 0.0, 80.0, maginsHeight*2+smallTextHright*2);
    canvas.drawRect(rect, paintRext);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}

