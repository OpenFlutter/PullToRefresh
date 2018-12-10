import 'package:flutter/material.dart';
import 'package:flutterapp/ui/firstpage/adsorptionviewdemo.dart';
import 'package:flutterapp/ui/firstpage/dragablegridviewdemo.dart';
import 'package:flutterapp/ui/secondpage/loginanimdemo.dart';
import 'package:flutterapp/ui/firstpage/pulltorefreshdemo.dart';
import 'package:flutterapp/bin/appinfobin.dart';
import 'package:flutterapp/ui/firstpage/animations.dart';
import 'package:flutterapp/ui/firstpage/marqueedemo.dart';
import 'package:flutterapp/ui/secondpage/timepicker.dart';

class FirstPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new FirdtPageState();
  }

}

class FirdtPageState extends State<FirstPage>{

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("CustomWidght",style: new TextStyle(fontSize: 18.0),),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.search),
            onPressed: null,
            iconSize: 29.0,
            disabledColor: Colors.white,)
          ]
        ,),
      body: new Container(
        // ignore: conflicting_dart_import
        child: new ListViewWidgets(),
      )
    );
  }
}


class ListViewWidgets extends StatefulWidget{

  var constantList =  [
    new AppInfoBin("Animations", "2018-07-09 17:30", "模仿京东品质潮男页面的动画效果",false),
    new AppInfoBin("MarqueeWidget", "2018-07-12 15:32", "跑马灯效果",false),
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
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new MarqueeWidgetDemo();
                }));
              }else if(index==2){
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
              }else if(index==3){
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
              }else if(index==4){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new AdsorptionViewDemo();
                }));
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