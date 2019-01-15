import 'package:flutter/material.dart';
import 'package:flutterapp/bin/appinfobin.dart';
import 'package:flutterapp/ui/secondpage/beziercurvedemo.dart';
import 'package:flutterapp/ui/secondpage/blendmode.dart';
import 'package:flutterapp/ui/secondpage/bubbles.dart';
import 'package:flutterapp/ui/secondpage/dashboard.dart';
import 'package:flutterapp/ui/secondpage/drawablestarttext.dart';
import 'package:flutterapp/ui/secondpage/loginanimdemo.dart';
import 'package:flutterapp/ui/secondpage/radarchartdemo.dart';
import 'package:flutterapp/ui/secondpage/timepicker.dart';

class SecondPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new SecondPageState();
  }

}

class SecondPageState extends State<SecondPage>{

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
    new AppInfoBin("IOSPicker", "2018-07-16 16:16", "自定义仿IOS时间选择器",false),
    new AppInfoBin("LoginAnimation", "2018-11-26 10:05", "登陆按钮的动画",false),
    new AppInfoBin("BlendMode", "2018-11-28 10:52", "BlendMode测试",false),
    new AppInfoBin("DashBoard", "2018-11-29 14:34", "汽车仪表盘模拟",false),
    new AppInfoBin("Bubbles", "2018-12-07 10:38", "泡泡往上冒的动画",false),
    new AppInfoBin("BezierCurve", "2018-12-26 16:00", "水波纹效果",false),
    new AppInfoBin("RadarChart", "2019-01-02 15:33", "雷达图（蜘蛛网图）",false),
    new AppInfoBin("DrawableStartText", "2019-01-10 09:27", "文字的开头添加标签",false),
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
                Navigator.of(context).push(new PageRouteBuilder(
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                    return new Timepicker();
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
              }else if(index==1){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new LoginAnimationDemo();
                }));
              }else if(index==2){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new BlendModes();
                }));
              }else if(index==3){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new DashBoard();
                }));
              }else if(index==4){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new Bubbles();
                }));
              }else if(index==5){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new BezierCurveDemo();
                }));
              }else if(index==6){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new RadarChartDemo();
                }));
              }else if(index==7){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new DrawableStartTextDemo();
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