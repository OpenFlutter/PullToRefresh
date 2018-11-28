import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterapp/components/pulltorefresh.dart';
//import 'package:pulltorefresh_flutter/pulltorefresh_flutter.dart';


class PullAndPushTest extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new PullAndPushTestState();
  }
}

///PullAndPush可以使用默认的样式，在此样式的基础上可以使用default**系列的属性改变显示效果，也可以自定义RefreshBox的样式（footerRefreshBox or headerRefreshBox）,也就是说可以定义其中一个，另一个用默认的，也可以全部自定义
///isPullEnable;isPushEnable属性可以控制RefreshBox 是否可用，无论是自定义的还是默认的
///PullAndPush can use the default style，Based on this style, you can use the properties of the default** series to change the display，
///You can also customize the style of the RefreshBox (footerRefreshBox or headerRefreshBox), which means you can define one of them, and the other can be customized by default or all.
class PullAndPushTestState extends State<PullAndPushTest> with TickerProviderStateMixin{
  List<String> addStrs=["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"];
  List<String> strs=["1","2","3","4","5","6","7","8","9","0"];
  ScrollController controller=new ScrollController();
  //For compatibility with ios ,must use RefreshAlwaysScrollPhysics ;为了兼容ios 必须使用RefreshAlwaysScrollPhysics
  ScrollPhysics scrollPhysics=new RefreshAlwaysScrollPhysics();
  //使用系统的请求
  var httpClient = new HttpClient();
  var url = "https://github.com/";
  var _result="";
  String customRefreshBoxIconPath="images/icon_arrow.png";
  AnimationController customBoxWaitAnimation;
  int rotationAngle=0;
  String customHeaderTipText="快尼玛给老子松手！";
  String defaultRefreshBoxTipText="快尼玛给老子松手！";


  @override
  void initState() {
    super.initState();
    //这个是刷新时控件旋转的动画，用来使刷新的Icon动起来
    customBoxWaitAnimation=new AnimationController(duration: const Duration(milliseconds: 1000*100), vsync: this);
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("上下拉刷新"),
      ),
      body: new PullAndPush(
        //如果你headerRefreshBox和footerRefreshBox全都自定义了，则default**系列的属性均无效，假如有一个RefreshBox是用默认的（在该RefreshBox Enable的情况下）则default**系列的属性均有效
        //If your headerRefreshBox and footerRefreshBox are all customizable，then the default** attributes of the series are invalid，
        // If there is a RefreshBox is the default（In the case of the RefreshBox Enable）then the default** attributes of the series are valid
        defaultRefreshBoxTipText: defaultRefreshBoxTipText,
        headerRefreshBox: _getCustomHeaderBox(),

        //你也可以自定义底部的刷新栏；you can customize the bottom refresh box
        animationStateChangedCallback:(AnimationStates animationStates,RefreshBoxDirectionStatus refreshBoxDirectionStatus){
          _handleStateCallback( animationStates, refreshBoxDirectionStatus);
        },
        listView: new ListView.builder(
          //ListView的Item
          itemCount: strs.length,//+2,
          controller: controller,
          physics: scrollPhysics,
          itemBuilder: (BuildContext context,int index){
            return new Container(
              height: 35.0,
              child: new Center(
                child: new Text(strs[index],style: new TextStyle(fontSize: 18.0),),
              ),
            );
          }
        ),
        loadData: (isPullDown) async{
          await _loadData(isPullDown);
        },
        scrollPhysicsChanged: (ScrollPhysics physics) {
          //这个不用改，照抄即可；This does not need to change，only copy it
          setState(() {
            scrollPhysics=physics;
          });
        },
      )
    );
  }



  Widget _getCustomHeaderBox(){
    return new Container(
        color: Colors.grey,
        child:  new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Align(
              alignment: Alignment.centerLeft,
              child: new RotatedBox(
                quarterTurns: rotationAngle,
                child: new RotationTransition( //布局中加载时动画的weight
                  child: new Image.asset(
                    customRefreshBoxIconPath,
                    height: 45.0,
                    width: 45.0,
                  ),
                  turns: new Tween(
                      begin: 100.0,
                      end: 0.0
                  )
                      .animate(customBoxWaitAnimation)
                    ..addStatusListener((animationStatus) {
                      if (animationStatus == AnimationStatus.completed) {
                        customBoxWaitAnimation.repeat();
                      }
                    }
                  ),
                ),
              ),
            ),

            new Align(
              alignment: Alignment.centerRight,
              child:new ClipRect(
//                child:new Text(customHeaderTipText,style: new TextStyle(fontSize: 18.0,color: Color(0xffe6e6e6)),),
                child:new Text(customHeaderTipText,style: new TextStyle(fontSize: 18.0,color: Colors.blue),),
              ),
            ),
          ],
        )
    );
  }

  void _handleStateCallback(AnimationStates animationStates,RefreshBoxDirectionStatus refreshBoxDirectionStatus){
    switch (animationStates){
    //RefreshBox高度达到50,上下拉刷新可用;RefreshBox height reached 50，the function of load data is  available
      case AnimationStates.DragAndRefreshEnabled:
        setState(() {
          //3.141592653589793是弧度，角度为180度,旋转180度；3.141592653589793 is radians，angle is 180⁰，Rotate 180⁰
          rotationAngle=2;
        });
        break;

    //开始加载数据时；When loading data starts
      case AnimationStates.StartLoadData:
        setState(() {
          customRefreshBoxIconPath="images/refresh.png";
          customHeaderTipText="正尼玛在拼命加载.....";
        });
        customBoxWaitAnimation.forward();
        break;

    //加载完数据时；RefreshBox会留在屏幕2秒，并不马上消失，这里可以提示用户加载成功或者失败
    // After loading the data，RefreshBox will stay on the screen for 2 seconds, not disappearing immediately，Here you can prompt the user to load successfully or fail.
      case AnimationStates.LoadDataEnd:
        customBoxWaitAnimation.reset();
        setState(() {
          rotationAngle = 0;
          if(refreshBoxDirectionStatus==RefreshBoxDirectionStatus.PULL) {
            customRefreshBoxIconPath = "images/icon_cry.png";
            customHeaderTipText = "加载失败！请重试";
          }else if(refreshBoxDirectionStatus==RefreshBoxDirectionStatus.PUSH){
            defaultRefreshBoxTipText="可提示用户加载成功Or失败";
          }
        });
        break;

    //RefreshBox已经消失，并且闲置；RefreshBox has disappeared and is idle
      case AnimationStates.RefreshBoxIdle:
        setState(() {
          rotationAngle=0;
          defaultRefreshBoxTipText=customHeaderTipText="快尼玛给老子松手！";
          customRefreshBoxIconPath="images/icon_arrow.png";
        });
        break;
    }
  }

  Future _loadData(bool isPullDown) async{
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        _result = await response.transform(utf8.decoder).join();
        setState(() {
          //拿到数据后，对数据进行梳理
          if(isPullDown){
            strs.clear();
            strs.addAll(addStrs);
          }else{
            strs.addAll(addStrs);
          }
        });
      } else {
        _result = 'error code : ${response.statusCode}';
      }
    } catch (exception) {
      _result = '网络异常';
    }
    print(_result);
  }
}






