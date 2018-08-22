import 'dart:async';

import 'package:flutter/material.dart';

class DragAbleGridView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new DragAbleGridViewState();
  }
}

class DragAbleGridViewState extends State<DragAbleGridView> with SingleTickerProviderStateMixin{

  var physics=new ScrollPhysics();
  double screenWidth;
  double screenHeight;
  List<ItemBin> itemBins=new List();
  List<int> itemPositions;

  double itemWidth;
  double itemHeight;
  double itemWidthChild;
  double itemHeightChild;
  double crossAxisSpacing=10.0;
  double theMarginsOfParentWid;
  double theMarginsOfParentHei;

  Animation<double> animation;
  AnimationController controller;

  int startPosition;
  int endPosition;
  bool isRest=false;
  int crossAxisCount=4;
  double areaCoverageRatio=2/3;


  @override
  void initState() {
    super.initState();

    controller = new AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    animation = new Tween(begin:0.0,end: 1.0).animate(controller)
      ..addListener(() {
        if(isRest){
          if(startPosition>endPosition){
            for(int i=endPosition; i<startPosition;i++){
              //图标向右 下移动
              if((i+1)%4==0){
                itemBins[itemPositions[i]].lastTimePositionX = -(screenWidth-itemWidth ) * 1+itemBins[itemPositions[i]].lastTimePositionX;
                itemBins[itemPositions[i]].lastTimePositionY = (itemHeight + 10) * 1+itemBins[itemPositions[i]].lastTimePositionY ;
              }else {
                itemBins[itemPositions[i]].lastTimePositionX = (itemWidth + 10) * 1+itemBins[itemPositions[i]].lastTimePositionX ;
              }
            }
          }else{
            for(int i=startPosition+1;i<=endPosition;i++){
              //图标向左 上移动
              if(i%4==0){
                itemBins[itemPositions[i]].lastTimePositionX = (screenWidth-itemWidth ) * 1+itemBins[itemPositions[i]].lastTimePositionX;
                itemBins[itemPositions[i]].lastTimePositionY = -(itemHeight + 10) * 1+itemBins[itemPositions[i]].lastTimePositionY;
              }else{
                itemBins[itemPositions[i]].lastTimePositionX = -(itemWidth + 10) * 1+itemBins[itemPositions[i]].lastTimePositionX;
              }
            }
          }
          return;
        }
        setState(() {

          if(startPosition>endPosition){
            for(int i=endPosition; i<startPosition;i++){
              //图标向右 下移动
              if((i+1)%4==0){
                itemBins[itemPositions[i]].dragPointX = -(screenWidth-itemWidth ) * animation.value+itemBins[itemPositions[i]].lastTimePositionX;
                itemBins[itemPositions[i]].dragPointY = (itemHeight + 10) * animation.value+itemBins[itemPositions[i]].lastTimePositionY ;
              }else {
                itemBins[itemPositions[i]].dragPointX = (itemWidth + 10) * animation.value+itemBins[itemPositions[i]].lastTimePositionX ;
              }
            }
          }else{
            for(int i=startPosition+1;i<=endPosition;i++){
              //图标向左 上移动
              if(i%4==0){
                itemBins[itemPositions[i]].dragPointX = (screenWidth-itemWidth ) * animation.value+itemBins[itemPositions[i]].lastTimePositionX;
                itemBins[itemPositions[i]].dragPointY = -(itemHeight + 10) * animation.value+itemBins[itemPositions[i]].lastTimePositionY;
              }else{
                itemBins[itemPositions[i]].dragPointX = -(itemWidth + 10) * animation.value+itemBins[itemPositions[i]].lastTimePositionX;
              }
            }
          }
        });
      });
    animation.addStatusListener((animationStatus){
      if(animationStatus==AnimationStatus.completed){
        setState(() {});
          isRest=true;
          controller.reset();
          isRest=false;

          print("startposition $startPosition**********endPosition $endPosition");
          int dragPosition=itemPositions[startPosition];
          itemPositions.removeAt(startPosition);
          itemPositions.insert(endPosition, dragPosition);
          print(itemBins[itemPositions[4]].data);
          startPosition=endPosition;

      }else if(animationStatus==AnimationStatus.forward){

      }
    });



    itemBins.add(new ItemBin("鲁班"));
    itemBins.add(new ItemBin("虞姬"));
    itemBins.add(new ItemBin("甄姬"));
    itemBins.add(new ItemBin("黄盖"));
    itemBins.add(new ItemBin("张飞"));
    itemBins.add(new ItemBin("关羽"));
    itemBins.add(new ItemBin("刘备"));
    itemBins.add(new ItemBin("曹操"));
    itemBins.add(new ItemBin("赵云"));
    itemBins.add(new ItemBin("孙策"));
    itemBins.add(new ItemBin("庄周"));
    itemBins.add(new ItemBin("廉颇"));
    itemBins.add(new ItemBin("后裔"));
    itemBins.add(new ItemBin("妲己"));
    itemBins.add(new ItemBin("荆轲"));
    _initItemPositions();
  }

  void _initItemPositions(){
    itemPositions=new List();
    for(int i=0;i<itemBins.length;i++){
      itemPositions.add(i);
    }
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Size screenSize=MediaQuery.of(context).size;
    screenWidth=screenSize.width;
    screenHeight=screenSize.height;
  }

  void _handLongPress(int index) async{
    await Future.delayed(new Duration(milliseconds: 800));
    if(itemBins[index].isLongPress){
      setState(() {
        itemBins[index].dragAble=true;
        startPosition=index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("可拖拽GridView"),
      ),
      body: new NotificationListener(
        onNotification: (onNotifications){

        },
        child: new GridView.builder(
          physics: physics,
          itemCount: itemBins.length,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: crossAxisCount,childAspectRatio: 1.8,crossAxisSpacing: crossAxisSpacing,mainAxisSpacing: crossAxisSpacing),
          itemBuilder: (BuildContext contexts,int index){
            return new GestureDetector(
              onTapDown: (detail){

                //获取控件y坐标
                double ss=itemBins[index].containerKey.currentContext.findRenderObject().getTransformTo(null).getTranslation().y;
                double aa=itemBins[index].containerKey.currentContext.findRenderObject().getTransformTo(null).getTranslation().x;
                itemWidth=itemBins[index].containerKey.currentContext.findRenderObject().paintBounds.size.width;
                itemHeight=itemBins[index].containerKey.currentContext.findRenderObject().paintBounds.size.height;
                itemWidthChild=itemBins[index].containerKeyChild.currentContext.findRenderObject().paintBounds.size.width;
                itemHeightChild=itemBins[index].containerKeyChild.currentContext.findRenderObject().paintBounds.size.height;
                theMarginsOfParentWid=(itemWidth-itemWidthChild)/2;
                theMarginsOfParentHei=(itemHeight-itemHeightChild)/2;
                itemBins[index].dragPointY=detail.globalPosition.dy-ss-itemHeight/2;
                itemBins[index].dragPointX=detail.globalPosition.dx-aa-itemWidth/2;
                itemBins[index].isLongPress=true;
                itemBins[index].dragAble=false;
                endPosition=index;
                _handLongPress(index);
              },
              onPanUpdate: (updateDetail){
                itemBins[index].isLongPress=false;
                if(itemBins[index].dragAble) {
                  itemBins[index].dragPointY += updateDetail.delta.dy;
                  itemBins[index].dragPointX += updateDetail.delta.dx;

                  if((itemBins[index].dragPointX.abs()>crossAxisSpacing+theMarginsOfParentWid+itemWidth*areaCoverageRatio
                          ||itemBins[index].dragPointY.abs()>crossAxisSpacing+theMarginsOfParentHei+itemHeight*areaCoverageRatio)
                      &&((itemBins[index].dragPointX-theMarginsOfParentWid)%(itemWidth+crossAxisSpacing).abs()>areaCoverageRatio*itemWidth
                          ||(itemBins[index].dragPointY-theMarginsOfParentHei)%(itemHeight+crossAxisSpacing).abs()>areaCoverageRatio*itemHeight)){
                    int y=0;
                    int x=0;


                    if((itemBins[index].dragPointY-theMarginsOfParentHei)~/(itemHeight+crossAxisSpacing)==0.0){
                      if(itemBins[index].dragPointY.abs()>=itemHeight*areaCoverageRatio+crossAxisSpacing+theMarginsOfParentHei){
                        if(itemBins[index].dragPointY<0){
                          y=index-crossAxisCount;
                        }else{
                          y=index+crossAxisCount;
                        }
                      }
                    }else{
                      if(itemBins[index].dragPointY<0){
                        y=index+((itemBins[index].dragPointY-theMarginsOfParentHei)~/(itemHeight+crossAxisSpacing))*crossAxisCount;
                        if((itemBins[index].dragPointY-theMarginsOfParentHei)%(itemHeight+crossAxisSpacing).abs()>=itemHeight*areaCoverageRatio+crossAxisSpacing+theMarginsOfParentHei){
                          y=y-crossAxisCount;
                        }
                      }else{
                        y=index+((itemBins[index].dragPointY-theMarginsOfParentHei)~/(itemHeight+crossAxisSpacing))*crossAxisCount;
                        if((itemBins[index].dragPointY-theMarginsOfParentHei)%(itemHeight+crossAxisSpacing).abs()>=itemHeight*areaCoverageRatio+crossAxisSpacing+theMarginsOfParentHei){
                          y=y+crossAxisCount;
                        }
                      }
                    }


                    if((itemBins[index].dragPointX-theMarginsOfParentWid)~/(itemWidth+crossAxisSpacing)==0) {
                      if(itemBins[index].dragPointX.abs()>=itemWidth*areaCoverageRatio+crossAxisSpacing+theMarginsOfParentWid){
                        if (itemBins[index].dragPointX < 0.0) {
                          x=-1;
                        } else {
                          x=1;
                        }
                      }

                    }else{
                      if (itemBins[index].dragPointX < 0.0) {
                        x=(itemBins[index].dragPointX-theMarginsOfParentWid)~/(itemWidth+crossAxisSpacing);
                        if((itemBins[index].dragPointX-theMarginsOfParentWid)%(itemWidth+crossAxisSpacing).abs()>=itemWidth*areaCoverageRatio+crossAxisSpacing+theMarginsOfParentWid){
                          x=x-1;
                        }
                      } else {
                        x=(itemBins[index].dragPointX-theMarginsOfParentWid)~/(itemWidth+crossAxisSpacing);
                        if((itemBins[index].dragPointX-theMarginsOfParentWid)%(itemWidth+crossAxisSpacing).abs()>=itemWidth*areaCoverageRatio+crossAxisSpacing+theMarginsOfParentWid){
                          x=x+1;
                        }
                      }
                    }

                    if(endPosition!=x+y&&!controller.isAnimating){
                      endPosition=x+y;
                      controller.forward();
                    }
                  }
                  setState(() {});
                }
              },
              onPanEnd: (upDetail){
                itemBins[index].isLongPress=false;
                if(!itemBins[index].dragAble) {
                  itemBins[index].dragPointY = 0.0;
                  itemBins[index].dragPointX = 0.0;
                }else {
                  setState(() {
                    List<ItemBin> itemBi = new List();
                    ItemBin bin;
                    for (int i = 0; i < itemPositions.length; i++) {
                      bin=itemBins[itemPositions[i]];
                      bin.dragPointX = 0.0;
                      bin.dragPointY = 0.0;
                      bin.lastTimePositionX = 0.0;
                      bin.lastTimePositionY = 0.0;
                      itemBi.add(bin);
                    }
                    itemBins.clear();
                    itemBins.addAll(itemBi);
                    _initItemPositions();
                  });
                }
              },
              child:new Container(
                alignment: Alignment.center,
                //color: Colors.grey,
                key: itemBins[index].containerKey,
                child: new OverflowBox(
                  maxWidth: screenWidth,
                  maxHeight: screenHeight,
                  alignment: Alignment.center,
                  child: new Center(
                    child: new Container(
                      key: itemBins[index].containerKeyChild,
                      transform: new Matrix4.translationValues(itemBins[index].dragPointX, itemBins[index].dragPointY, 0.0),
                      padding: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(new Radius.circular(3.0)),
                        border: new Border.all(color: Colors.blue),
                      ),
                      child: new Text(
                        itemBins[index].data,
                        style: new TextStyle(fontSize: 16.0,color: Colors.blue),),
                    ),
                  )
                ),
              ),
            );
          })
      )
    );
  }
}

class ItemBin{

  ItemBin( this.data);

  String data;
  double dragPointX=0.0;
  double dragPointY=0.0;
  double lastTimePositionX=0.0;
  double lastTimePositionY=0.0;
  GlobalKey containerKey=new GlobalKey();
  GlobalKey containerKeyChild=new GlobalKey();
  bool isLongPress=false;
  bool dragAble=false;
}