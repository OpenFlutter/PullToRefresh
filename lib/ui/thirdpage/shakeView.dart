import 'dart:math';

import 'package:flutter/material.dart';

class ShakeView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new ShakeViewState();
  }
}

class ShakeViewState extends State<ShakeView> with SingleTickerProviderStateMixin<ShakeView>{

  Animation<double> animation;
  AnimationController animationController;
  double rotateAngle=0.0;
  Random _random=new Random();
  double doubleAngle ;
  var listInfo =[-0.05,0.03,0.04,-0.02,0.05,-0.04,0.02,0.05,-0.03,0.04,0.03,-0.06,0.02,-0.05,0.03,0.04,-0.02,0.05,-0.04,0.02,0.05,-0.03];
  var listAngles =[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
  int count = 0;
  bool isTiming = false;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(duration: const Duration(milliseconds: 300), vsync: this,animationBehavior: AnimationBehavior.preserve);

    animation = new Tween(begin: 0.0, end: 2.0).animate(animationController)
      ..addListener(() {
        double  animationValue  = animation.value;
        setState(() {
          for(int i =0 ;i< listInfo.length;i++){
            doubleAngle = listInfo[i] *2;
            if(animationValue<=0.5){
              listAngles[i] = animationValue * doubleAngle;
            }else if(animationValue<=1.0){
              listAngles[i] = (1-animationValue) * doubleAngle;
            }else if(animationValue<=1.5){
              listAngles[i] = -(animationValue-1.0) * doubleAngle;
            }else{
              listAngles[i] = -(2.0-animationValue) * doubleAngle;
            }
          }
        });
        if(animationValue==2.0){
          changeData();
        }
      });
  }

  void  changeData()async{
    print("changeData");
    if(count%3 == 0){
      int d;
      double c;
      for(int i =0 ;i< listInfo.length;i++){
        d = _random.nextInt(10);
        if(d>5){
          c = listInfo[i] = listInfo[i]+0.01;
        }else{
          c = listInfo[i] = listInfo[i]-0.01;
        }

        if(c<0.02 && c >=0){
          listInfo[i] = 0.03;
        }else if(c>-0.02 && c <=0){
          listInfo[i] = -0.03;
        }else if(c<-0.07){
          listInfo[i] = -0.06;
        }else if(c>0.07){
          listInfo[i] = 0.06;
        }
      }
    }
    count++;
  }




  void startTiming() async{
    while(isTiming) {
      await Future.delayed(Duration(milliseconds: 300 * 3));
      if(isTiming){
        changeData();
      }
    }
  }


  void _onLongPress(){
    if(animationController.isAnimating){
      return;
    }
    isTiming=true;
    startTiming();
    animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("ShakeView"),
        actions: <Widget>[
          new GestureDetector(
            onTap: (){
              if(animationController.isAnimating){
                isTiming = false;
                animationController.stop();
              }
              setState(() {
                listAngles =[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
              });
            },
            child: new Container(
              padding: EdgeInsets.all(5),
              child: new Text("完成"),
            ),
          ),
        ],
      ),
      body: new Column(
        children: <Widget>[
          getRows(0),
          getRows(4),
          getRows(8),
          getRows(12),
          getRows(16),
          getRowsLess(),
        ],
      ),
    );
  }


  Widget getRows(int miniPosition){
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        getItem(miniPosition),
        getItem(miniPosition+1),
        getItem(miniPosition+2),
        getItem(miniPosition+3),
      ],
    );
  }

  Widget getRowsLess(){
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        getItem(20),
        getItem(21),
        new Container(
          margin: EdgeInsets.all(10),
          height: 60,
          width: 60,
        ),
        new Container(
          margin: EdgeInsets.all(10),
          height: 60,
          width: 60,
        ),
      ],
    );
  }


  Widget getItem(int position){
    return new GestureDetector(
      onLongPress: (){
        _onLongPress();
      },
      child:Transform.rotate(
        origin: new Offset(0, 0),
        angle: listAngles[position],
        child: new Container(
          margin: EdgeInsets.all(10),
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    isTiming = false;
    animationController.dispose();
    super.dispose();
  }
}