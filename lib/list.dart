import 'package:flutter/material.dart';
import 'package:flutterapp/adsorptionviewdemo.dart';
import 'package:flutterapp/dragablegridviewdemo.dart';
import 'package:flutterapp/pulltorefreshdemo.dart';
import './bin/appinfobin.dart';
import './animations.dart';
import './marqueedemo.dart';
import './timepicker.dart';

class ListViewWidgets extends StatefulWidget{

  var constantList =  [
    new AppInfoBin("Animations", "2018-07-09 17:30", "模仿京东品质潮男页面的动画效果",false),
    new AppInfoBin("MarqueeWidget", "2018-07-12 15:32", "跑马灯效果",false),
    new AppInfoBin("IOSPicker", "2018-07-16 16:16", "自定义仿IOS时间选择器",false),
    new AppInfoBin("PullAndPush", "2018-07-27 09:45", "上下拉刷新",false),
    new AppInfoBin("DragAbleGridView", "2018-08-15 15:30", "可拖拽的GridView",false),
    new AppInfoBin("AdsorptionView", "2018-09-06 16:30", "可以吸附顶部的布局",false),
  ];

  @override
  State<StatefulWidget> createState() {
    return new ListState();
  }

}

class ListState extends State<ListViewWidgets>{
  
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: widget.constantList.length,
        itemBuilder: (BuildContext context,int index){
          return new GestureDetector(
            onTapDown: (TapDownDetails details){
              setState(() {
                widget.constantList[index].isTapDown=true;
              });
            },
            onTapCancel: (){
              setState(() {
                widget.constantList[index].isTapDown=false;
              });
            },
            onTapUp:(TapUpDetails details){
              setState(() {
                widget.constantList[index].isTapDown=false;
              });
              if(index==0){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new AnimationWidget();
                }));
              }else if(index==1){
                Navigator.of(context).push(new PageRouteBuilder(
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                    return new MarqueeWidgetDemo();
                  },
                  transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                    return AnimatedBuilder (
                      child: child,
                      animation: animation,
                      builder: (BuildContext context, Widget child) {
                            return new Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationZ(animation.value*1.0-1.0)..scale(animation.value*0.5+0.5,animation.value*0.5+0.5,animation.value*0.5+0.5),
                              child:new Opacity(
                                child: child,
                                opacity: animation.value*0.7+0.3,
                              ),
                            );
                          }
                        );
                      },
                  ),
                );
              }else if(index==2){
                Navigator.of(context).push(new PageRouteBuilder(
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                    return new Timepicker();
                  },
                  transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                    return RotationTransition (
                      turns: new Tween<double>(
                        begin: -0.5,
                        end: 0.0,
                      ).animate(animation),
                      child: child,
                    );
                  },
                ));
              }else if(index==3){
                Navigator.of(context).push(new PageRouteBuilder(
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                    return new PullAndPushTest();
                  },
                  transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                    return SlideTransition(
                      position: new Tween<Offset>(
                        begin: const Offset(-1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                ));
              }else if(index==4){
                Navigator.of(context).push(new PageRouteBuilder(
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                    return new DragAbleGridViewDemo();
                  },
                  transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                    return ScaleTransition(
                      scale: new Tween<double>(
                        begin: 0.3,
                        end: 1.0,
                      ).animate(animation),
                      child: child,
                    );
                  },
                ));
              }else if(index==5){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new AdsorptionViewDemo();
                }));
              }else if(index==6){

              }
            },
            child:new Card(
              color: widget.constantList[index].isTapDown?Color(0xFFF4CB28):null,
              child: new Container(
                padding: new EdgeInsets.all(10.0),
                child: new ListTile(
                  subtitle: new Container(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text(widget.constantList[index].title,style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Colors.black),)
                          ],
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new Text("时间",style: new TextStyle(fontSize: 13.0)),
                                new Text(widget.constantList[index].times,style: new TextStyle(fontSize: 13.0)),
                              ],
                            )
                          ],
                        ),
                        new Row(
                          children: <Widget>[
                            new Expanded(
                              child:new Container(
                                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 2.0),
                                child: new Text(widget.constantList[index].content,maxLines: 1,overflow: TextOverflow.ellipsis,),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  trailing: new Icon(Icons.keyboard_arrow_right,color: Colors.grey,),
                ),
              ),
            )
          );
        },);
  }
  
}