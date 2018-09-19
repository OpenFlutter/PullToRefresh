import 'package:flutter/material.dart';
import 'package:flutterapp/adsorptionview.dart';
import 'package:flutterapp/dragablegridview.dart';
import 'package:flutterapp/pullandpush.dart';
import './randomwords.dart';
import './shoppinglist.dart';
import './myappbar.dart';
import './materialappbar.dart';
import './gesturedetector.dart';
import './chartanimations.dart';
import './bin/appinfobin.dart';
import './networkstudy.dart';
import './gridlist.dart';
import './inkwell.dart';
import './dismissibleitem.dart';
import './animations.dart';
import './marquee.dart';
import './cupertinopicker.dart';
import './timepicker.dart';

class ListViewWidgets extends StatefulWidget{

  var constantList =  [
    new AppInfoBin("ShoppingList", "2018-06-27 10:18", "包含点击事件，Icon变色，字体改变和Flutter路由（页面切换）",false),
    new AppInfoBin("MyAppBar", "2018-06-27 11:26", "非Material风格的AppBar编写",false),
    new AppInfoBin("MaterialAppBar", "018-06-27 12:30", "Material风格的APPBar，和FloatingActionButton控件的使用",false),
    new AppInfoBin("GestureDetector", "018-06-27 13:38", "GestureDetector控件如何响应点击 手势事件的控制",false),
    new AppInfoBin("RandomWords", "018-06-27 15:01", "引用第三方包动态生成单词组，并提供收藏功能，点击可查看收藏的单词",false),
    new AppInfoBin("ChartAnimations", "2018-06-28 16:18", "Chart表的动画",false),
    new AppInfoBin("Network", "2018-07-05 10:13", "网络请求的，包含网络图片，和网络Json的加载",false),
    new AppInfoBin("Grid List", "2018-07-06 16:27", "Grid List的创建",false),
    new AppInfoBin("InkWellC", "2018-07-06 17:05", "两种水波纹效果的演示",false),
    new AppInfoBin("DismissibleItem", "2018-07-09 09:01", "滑动删除Item的展示",false),
    new AppInfoBin("Animations", "2018-07-09 17:30", "模仿京东品质潮男页面的动画效果",false),
    new AppInfoBin("MarqueeWidget", "2018-07-12 15:32", "跑马灯效果",false),
    new AppInfoBin("CupertinoPicker", "2018-07-16 09:09", "仿IOS时间选择器",false),
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
                  return new ShoppingList();
                }));
              }else if(index==1){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new MyScaffold();
                }));
              }else if(index==2){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new TutorialHome();
                }));
              }else if(index==3){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new MyButton();
                }));
              }else if(index==4){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new MyApp('路由是个好东西，要进一步封装');
                }));
              }else if(index==5){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new ChartPage();
                }));
              }else if(index==6){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new NetWorkCls();
                }));
              }else if(index==7){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new GridList();
                }));
              }else if(index==8){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new InkWellC();
                }));
              }else if(index==9){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new DismissibleItem();
                }));
              }else if(index==10){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new AnimationWidget();
                }));
              }else if(index==11){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new MarqueeWidget();
                }));
              }else if(index==12){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new CupertinoPickerDemo();
                }));
              }else if(index==13){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new Timepicker();
                }));
              }else if(index==14){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new PullAndPushTest();
                }));
              }else if(index==15){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new DragAbleGridView();
                }));
              }else if(index==16){
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return new AdsorptionView();
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