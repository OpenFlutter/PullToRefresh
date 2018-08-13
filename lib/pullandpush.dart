import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PullAndPush extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new PullAndPushState();
  }
}

class PullAndPushState extends State<PullAndPush> with TickerProviderStateMixin{

  List<String> addStrs=["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"];
  List<String> strs=["1","2","3","4","5","6","7","8","9","0"];
  ScrollController controller=new ScrollController();
  double topItemHeight=0.0;
  double bottomItemHeight=0.0;
  ScrollPhysics scrollPhysics=new AlwaysScrollableScrollPhysics();
  Animation<double> animation;
  AnimationController animationController;
  double shrinkageDistance=0.0;
  final double _refreshHeight=50.0;
  StateModule states=StateModule.IDLE;

  AnimationController animationControllerWait;

  bool isReset=false;
  bool isPulling=false;
  Color backgroundColor=Colors.grey;
  String refreshIconPath="images/refresh.png";

  String tipText="松手即可刷新";



  @override
  void initState() {
    super.initState();
    //这个是刷新时控件旋转的动画，用来使刷新的Icon动起来
    animationControllerWait=new AnimationController(duration: const Duration(milliseconds: 1000*100), vsync: this);

    animationController = new AnimationController(duration: const Duration(milliseconds: 250), vsync: this);
    animation = new Tween(begin: 1.0, end: 0.0).animate(animationController)
      ..addListener(() {
        //因为animationController reset()后，addListener会收到监听，导致再执行一遍setState topItemHeight和bottomItemHeight会异常 所以用此标记
        //判断是reset的话就返回避免异常
        if(isReset){
          return;
        }
        //根据动画的值逐渐减小布局的高度，分为4种情况
        // 1.上拉高度超过_refreshHeight    2.上拉高度不够50   3.下拉拉高度超过_refreshHeight  4.下拉拉高度不够50
        setState(() {
          if(topItemHeight>_refreshHeight){
            //shrinkageDistance*animation.value是由大变小的，模拟出弹回的效果
            topItemHeight=_refreshHeight+shrinkageDistance*animation.value;
          }else if(bottomItemHeight>_refreshHeight){
            bottomItemHeight=_refreshHeight+shrinkageDistance*animation.value;
            //高度小于50时↓
          }else if(topItemHeight<=_refreshHeight&&topItemHeight>0){
            topItemHeight=shrinkageDistance*animation.value;
          }else if(bottomItemHeight<=_refreshHeight&&bottomItemHeight>0){
            bottomItemHeight=shrinkageDistance*animation.value;
          }
        });
      });
    animation.addStatusListener((animationStatus){
      if(animationStatus==AnimationStatus.completed){
        //动画结束时首先将animationController重置
          isReset=true;
          animationController.reset();
          isReset=false;
          //动画完成后只有2种情况，高度是50和0，如果是高度》=50的，则开始刷新或者加载操作，如果是0则恢复ListView
          setState(() {
            if(topItemHeight>=_refreshHeight){
                topItemHeight=_refreshHeight;
                refreshStart();
            }else if(bottomItemHeight>=_refreshHeight){
                bottomItemHeight=_refreshHeight;
                refreshStart();
            //动画结束，高度回到0，上下拉刷新彻底结束，ListView恢复正常
            }else if(states==StateModule.PUSH){
                topItemHeight=0.0;
                scrollPhysics=new AlwaysScrollableScrollPhysics();
                states=StateModule.IDLE;
            }else if(states==StateModule.PULL){
                bottomItemHeight=0.0;
                scrollPhysics=new AlwaysScrollableScrollPhysics();
                states=StateModule.IDLE;
                isPulling=false;
            }
          });
      }else if(animationStatus==AnimationStatus.forward){
        print("****************Start Animation**********************");
        //动画开始时根据情况计算要弹回去的距离
        if(topItemHeight>_refreshHeight){
          shrinkageDistance=topItemHeight-_refreshHeight;
        }else if(bottomItemHeight>_refreshHeight){
          shrinkageDistance=bottomItemHeight-_refreshHeight;
          //这里必须有个动画，不然上拉加载时  ListView不会自动滑下去，导致ListView悬在半空
          controller.animateTo(controller.position.maxScrollExtent, duration: new Duration(milliseconds: 250), curve: Curves.linear);
        }else if(topItemHeight<=_refreshHeight&&topItemHeight>0.0){
          shrinkageDistance=topItemHeight;
          states=StateModule.PUSH;
        }else if(bottomItemHeight<=_refreshHeight&&bottomItemHeight>0.0){
          shrinkageDistance=bottomItemHeight;
          states=StateModule.PULL;
        }
      }
    });
  }

  //使用系统的请求
  var httpClient = new HttpClient();
  var url = "https://github.com/";
  var _result="";

  void refreshStart () {
    startWaitAnimation();
    //TODO 做一些事情
    _loadData();
  }

  _loadData() async {
    //这里我们开始加载数据 数据加载完成后，将新数据处理并开始加载完成后的处理
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        _result = await response.transform(UTF8.decoder).join();
      } else {
        _result = 'error code : ${response.statusCode}';
      }
    } catch (exception) {
      _result = '网络异常';
    }
    //拿到数据后，对数据进行梳理
    if(topItemHeight>0.0){
      strs.clear();
      strs.addAll(addStrs);
    }else if(bottomItemHeight>0.0){
      strs.addAll(addStrs);
    }
    print(_result);
    if (!mounted) return;
    //加载数据完成后的处理
    endWaitAnimation();
  }


  //开始加载等待的动画
  void startWaitAnimation(){
    animationControllerWait.forward();
  }

  //加载完成，结束加载等待的动画，开始将加载（刷新）布局缩回去
  void endWaitAnimation(){
    //开始将加载（刷新）布局缩回去的动画
    animationController.forward();
    //结束加载等待的动画
    animationControllerWait.reset();
  }


  dispose() {
    animationController.dispose();
    animationControllerWait.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("上下拉刷新"),
      ),
      body: new Container(
        child:new Column(
          children: <Widget>[
            new Container( //下拉刷新的布局
              color: backgroundColor,
              height: topItemHeight,
              child: new Center(
                child: new Container(
                  height: 50.0,  //在这里设置布局的宽高
                  width: 150.0,
                  child: new Row(
                    children: <Widget>[
                      new Align(
                        alignment: Alignment.centerLeft,
                        child:new RotationTransition(  //布局中加载时动画的weight
                          child: new Image.asset(refreshIconPath,height: 45.0,width: 45.0,),
                          turns: new Tween(begin: 100.0, end: 0.0).animate(animationControllerWait)
                            ..addStatusListener((animationStatus){
                              if(animationStatus==AnimationStatus.completed){
                                animationControllerWait.repeat();
                              }
                            }),
                        ),
                      ),

                      new Align(   //这里是布局中的文字
                        alignment: Alignment.centerRight,
                        child:new Text(tipText,style: new TextStyle(color: Colors.white),),
                      ),
                    ],
                  ),
                ),
              )
            ),
            new Expanded(
              flex:1,
              child: new NotificationListener(
                  onNotification: (ScrollNotification  notification){
                    ScrollMetrics metrics=notification.metrics;
                    //Header刷新的布局可见时，且当手指反方向拖动（由下向上），notification 为 ScrollUpdateNotification，这个时候让头部刷新布局的高度+delta.dy(此时dy为负数)
                    // 来缩小头部刷新布局的高度，当完全看不见时，将scrollPhysics设置为AlwaysScrollableScrollPhysics，来保持ListView的正常滑动
                    if(notification is ScrollUpdateNotification&&topItemHeight>0.0){
                        setState(() {
                          //如果头部的布局高度<0时，将topItemHeight=0；并恢复ListView的滑动
                          if(topItemHeight+notification.dragDetails.delta.dy/2<0.0){
                            topItemHeight=0.0;
                            scrollPhysics=new AlwaysScrollableScrollPhysics();
                          }else {
                            //当刷新布局可见时，让头部刷新布局的高度+delta.dy(此时dy为负数)，来缩小头部刷新布局的高度
                            topItemHeight = topItemHeight + notification.dragDetails.delta.dy / 2;
                          }
                        });
                    }else if(notification is ScrollUpdateNotification&&bottomItemHeight>0.0){
                        //底部的布局可见时 ，且手指反方向拖动（由上向下），这时notification 为 ScrollUpdateNotification，这个时候让底部加载布局的高度-delta.dy(此时dy为正数数)
                        //来缩小底部加载布局的高度，当完全看不见时，将scrollPhysics设置为AlwaysScrollableScrollPhysics，来保持ListView的正常滑动

                        //当上拉加载时，不知道什么原因，dragDetails可能会为空，导致抛出异常，会发生很明显的卡顿，所以这里必须判空
                        if(notification.dragDetails==null){
                          return true;
                        }
                        setState(() {
                          //如果底部的布局高度<0时，bottomItemHeight=0；并恢复ListView的滑动
                          if(bottomItemHeight-notification.dragDetails.delta.dy/2<0.0) {
                            bottomItemHeight=0.0;
                            scrollPhysics=new AlwaysScrollableScrollPhysics();
                          }else{
                            if(notification.dragDetails.delta.dy>0){
                              //当加载的布局可见时，让上拉加载布局的高度-delta.dy(此时dy为正数数)，来缩小底部的加载布局的高度
                              bottomItemHeight = bottomItemHeight - notification.dragDetails.delta.dy / 2;
                            }
                          }
                        });
                    }else if(notification is ScrollEndNotification){
                      //如果滑动结束后（手指抬起来后），判断是否需要启动加载或者刷新的动画

                        if((topItemHeight>0||bottomItemHeight>0)){
                          if(isPulling){
                            return true;
                          }
                          //这里在动画开始时，做一个标记，表示上拉加载正在进行，因为在超出底部和头部刷新布局的高度后，高度会自动弹回，ListView也会跟着运动，
                          //返回结束时，ListView的运动也跟着结束，会触发ScrollEndNotification，导致再次启动动画，而发生BUG
                          if(bottomItemHeight>0){
                            isPulling=true;
                          }
                          //启动动画后，ListView不可滑动
                          scrollPhysics=new NeverScrollableScrollPhysics();
                          animationController.forward();
                          //TODO 动画
                        }
                    }else if(notification is UserScrollNotification&&bottomItemHeight>0.0&&notification.direction==ScrollDirection.forward){
                      //底部加载布局出现反向滑动时（由上向下），将scrollPhysics置为RefreshScrollPhysics，只要有2个原因。1 减缓滑回去的速度，2 防止手指快速滑动时出现惯性滑动
                        setState(() {
                          scrollPhysics=new RefreshScrollPhysics();
                        });
                    }else if(notification is UserScrollNotification&&topItemHeight>0.0&&notification.direction==ScrollDirection.reverse){
                      ////头部刷新布局出现反向滑动时（由下向上）
                        setState(() {
                          scrollPhysics=new RefreshScrollPhysics();
                        });
                    }else if(notification is UserScrollNotification&&bottomItemHeight>0.0&&notification.direction==ScrollDirection.reverse){
                      //反向再反向（恢复正向拖动）
                        setState(() {
                          scrollPhysics=new AlwaysScrollableScrollPhysics();
                        });
                    }else if(metrics.atEdge&&notification is OverscrollNotification){
                      //OverscrollNotification 和 metrics.atEdge 说明正在下拉或者 上拉

                      //如果notification.overscroll<0.0 说明是在下拉刷新，这里根据拉的距离设定高度的增加范围-->小于50时  是拖动速度的1/2，高度在50-90时 是
                      //拖动速度的1/4  .........若果超过150，结束拖动，自动开始刷新，拖过刷新布局高度小于0，恢复ListView的正常拖动
                      //当Item的数量不能铺满全屏时  上拉加载会引起下拉布局的出现，所以这里要判断下bottomItemHeight<0.5
                      print(bottomItemHeight);
                      if(notification.overscroll<0.0&&bottomItemHeight<0.5){
                          setState(() {
                            if(notification.dragDetails.delta.dy/2+topItemHeight<0.0){
                              topItemHeight=0.0;
                              scrollPhysics=new AlwaysScrollableScrollPhysics();
                            }else{
                              if(topItemHeight>150.0){
                                scrollPhysics=new NeverScrollableScrollPhysics();
                                animationController.forward();
                                //TODO 动画
                              }else if(topItemHeight>90.0){
                                topItemHeight=notification.dragDetails.delta.dy/6+topItemHeight;
                              }else if(topItemHeight>50.0){
                                topItemHeight=notification.dragDetails.delta.dy/4+topItemHeight;
                              }else {
                                topItemHeight=notification.dragDetails.delta.dy/2+topItemHeight;
                              }
                            }
                          });
                      }else if(topItemHeight<0.5){
                        //此处同上
                          if(notification.dragDetails==null){
                            return true;
                          }
                          setState(() {
                            if(-notification.dragDetails.delta.dy/2+bottomItemHeight<0.0){
                              bottomItemHeight=0.0;
                              scrollPhysics=new AlwaysScrollableScrollPhysics();
                            }else{
                              if(bottomItemHeight>75.0){
                                if(isPulling){
                                  return;
                                }
                                isPulling=true;
                                scrollPhysics=new NeverScrollableScrollPhysics();
                                animationController.forward();
                                //TODO 动画
                              }else if(bottomItemHeight>60.0){
                                bottomItemHeight=-notification.dragDetails.delta.dy/6+bottomItemHeight;
                              }else if(bottomItemHeight>50.0){
                                bottomItemHeight=-notification.dragDetails.delta.dy/4+bottomItemHeight;
                              }else {
                                bottomItemHeight=-notification.dragDetails.delta.dy/2+bottomItemHeight;
                              }
                            }
                          });
                      }
                    }
                    print(notification);
                    return true;
                  },
                  child: new ListView.builder(
                      //ListView的Item
                      itemCount: strs.length+2,
                      controller: controller,
                      physics: scrollPhysics,
                      itemBuilder: (BuildContext context,int index){
                        if(index==0){
                          return new Container(
                            alignment: Alignment.bottomCenter,
                          );
                        }else if(index==strs.length+1){
                          return new Container(
                            alignment: Alignment.topCenter,
                          );
                        }
                        return new Container(
                          height: 35.0,
                          child: new Center(
                            child: new Text(strs[index-1],style: new TextStyle(fontSize: 18.0),),
                          ),
                        );
                      }
                  ),
                ),
            ),
            new Container(   //上拉加载布局
              alignment: Alignment.bottomCenter,
              color: backgroundColor,
              height: bottomItemHeight,
              child: new Center(
                child: new Container(
                  height: 50.0,
                  width: 150.0,
                  child: new Row(
                    children: <Widget>[
                      new Align(
                        alignment: Alignment.centerLeft,
                        child:new RotationTransition(
                          child: new Image.asset(refreshIconPath,height: 45.0,width: 45.0,),
                          turns: new Tween(begin: 100.0, end: 0.0).animate(animationControllerWait)
                            ..addStatusListener((animationStatus){
                              if(animationStatus==AnimationStatus.completed){
                                animationControllerWait.repeat();
                              }
                            }),
                        ),
                      ),

                      new Align(
                        alignment: Alignment.centerRight,
                        child:new Text(tipText,style: new TextStyle(color: Colors.white),),
                      ),
                    ],
                  ),
                ),
              )
            ),
          ],
        ),
      )
    );
  }
}

//切记 继承ScrollPhysics  必须重写applyTo，，在NeverScrollableScrollPhysics类里面复制就可以
class RefreshScrollPhysics extends ScrollPhysics {
  const RefreshScrollPhysics({ ScrollPhysics parent }) : super(parent: parent);

  @override
  RefreshScrollPhysics applyTo(ScrollPhysics ancestor) {
    return new RefreshScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    return true;
  }

  //重写这个方法为了减缓ListView滑动速度
  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    if(offset<0.0){
      return 0.00000000000001;
    }
    if(offset==0.0){
      return 0.0;
    }
    return offset/2;
  }


  //此处返回null时为了取消惯性滑动
  @override
  Simulation createBallisticSimulation(ScrollMetrics position, double velocity) {
    return  null;
  }
}

enum  StateModule {
  //  上拉加载的状态 分别为 闲置 上拉  下拉
  IDLE, PUSH, PULL
}

