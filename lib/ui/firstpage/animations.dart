import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

import 'package:flutter/rendering.dart';

class AnimationWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new AnimationState();
  }

}

class AnimationState extends State<AnimationWidget> with SingleTickerProviderStateMixin{

  final double imageWidth=90.0;
  final double imageHeight=160.0;
  Animation<double> animation;
  AnimationController controller;
  double preXPosition;
  double screenWidth;
  double magins;
  double scales=0.0;
  List<String> imagesPaths;
  bool directionLeft=true;

  @override
  void initState() {
    controller = new AnimationController(duration: const Duration(milliseconds: 430), vsync: this);
    animation = new Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
          if(directionLeft){
            scales=animation.value;
          }else{
            scales=1.0-animation.value;
          }
          print("**********");
        });
      });
    animation.addStatusListener((animationStatus){
        if(animationStatus==AnimationStatus.completed){
          setState(() {
            controller.reset();
            if(directionLeft){
              String a=imagesPaths[3];
              imagesPaths.removeLast();
              imagesPaths.insert(0, a);
            }
            scales=0.0;
          });

        }else if(animationStatus==AnimationStatus.forward){
          setState(() {
            if(!directionLeft){
              String a=imagesPaths[0];
              imagesPaths.removeAt(0);
              imagesPaths.add(a);
            }
          });
        }
      });

    super.initState();

    imagesPaths=new List();
    imagesPaths.add("images/chaonan3.jpeg");
    imagesPaths.add("images/chaonan4.jpeg");
    imagesPaths.add("images/chaonan2.jpg");
    imagesPaths.add("images/chaonan1.jpeg");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenWidth=MediaQuery.of(context).size.width;
    magins=(screenWidth-60-imageWidth*2.5)/2.0;
    print("magins is $magins");
  }



  /*  第一排的magn不用动 宽高不用动
   *  中间的View宽高放大 magin加大
   *  最后一排  也就是最前面的界面宽高不用动，magin快速变大
   */
  Row creatRow(double imgHeight,double imgWidth,double maginSize,String imgPath){
    return new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new Center(
          child: new Container(
            width: screenWidth,
            alignment: Alignment.centerRight,
            child: new OverflowBox(
              maxWidth: double.infinity,
              maxHeight: double.infinity,
              alignment: Alignment.centerRight,
              child: new Container(
                height: imgHeight,
                width: imgWidth,
                margin: new EdgeInsets.fromLTRB(0.0, 0.0, maginSize, 0.0),
                child: new Image.asset(imgPath),
              ),
            ),
          ),
        ),
      ],
    );
  }



  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("AnimationWidget"),
      ),
      body: new Center(
        child: new GestureDetector(
          onHorizontalDragDown: (getureDragDownCallback){
            print("onHorizontalDragDown");
          },
          onHorizontalDragStart: (getureDragStartCallback){
            preXPosition=getureDragStartCallback.globalPosition.dx;
          },
          onHorizontalDragUpdate: (getureDragUpdateCallback){
            if((preXPosition-getureDragUpdateCallback.globalPosition.dx)>50&&preXPosition!=0.0){
              print("动画启动");
              preXPosition=0.0;
              directionLeft=true;
              controller.forward();
            }else if((preXPosition-getureDragUpdateCallback.globalPosition.dx)<-50&&preXPosition!=0.0){
              print("动画启动");
              preXPosition=0.0;
              directionLeft=false;
              controller.forward();
            }
          },
          onHorizontalDragEnd: (getureDragEndCallback){
            preXPosition=0.0;
          },
          child:  new Stack(
            children: <Widget>[
              creatRow(imageHeight*1.9, imageWidth*1.9, 30.0, imagesPaths[0]),
              creatRow(imageHeight*(1.9+0.3*scales), imageWidth*(1.9+0.3*scales), 30.0+scales*magins, imagesPaths[1]),
              creatRow(imageHeight*(2.2+0.3*scales), imageWidth*(2.2+0.3*scales),magins+30+scales*magins,imagesPaths[2]),
              creatRow(imageHeight*2.5,imageWidth*2.5,magins*2+30+scales*(imageWidth*2.5+40),imagesPaths[3]),
            ],
          ),
        )
      ),
    );
  }
}