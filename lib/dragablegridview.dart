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
  double areaCoverageRatio=1/5;

  Timer timer;


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

          int dragPosition=itemPositions[startPosition];
          itemPositions.removeAt(startPosition);
          itemPositions.insert(endPosition, dragPosition);
          startPosition=endPosition;
//          for(int i=0;i<itemPositions.length;i++){
//            print("~~~~~~~~~~~itemPositions ${itemPositions[i]}~~~~~~~~~~~~~~~");
//          }

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
                  double dragPointY=itemBins[index].dragPointY += updateDetail.delta.dy;
                  double dragPointX=itemBins[index].dragPointX += updateDetail.delta.dx;
                  //print("dragPointX $dragPointX");
                  if(timer!=null&&timer.isActive){
                    timer.cancel();
                  }
                  timer=new Timer(new Duration(milliseconds: 100), (){
                    onFingerPause(index,dragPointX,dragPointY,updateDetail);
                  });

                  setState(() {});
                }
              },
              onPanEnd: (upDetail){
                itemBins[index].isLongPress=false;
                if(!itemBins[index].dragAble) {
                  itemBins[index].dragPointY = 0.0;
                  itemBins[index].dragPointX = 0.0;
                }else {
                  onPanEndEvent(index);
                }
//                for(int i=0;i<itemBins.length;i++){
//                  print("${itemBins[i].toString()}********${itemPositions[i]}");
//                }
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

  int onDragLessThanWidthX(int index,double dragPointX,bool isYDragable){
    int x;

    int a=itemPositions.indexOf(index);
    if((index==a||isYDragable)||(index!=a||!isYDragable)){
      return 0;
    }
    if (dragPointX < 0.0) {
      x=-1;
    } else {
      x=1;
    }
    return x;
  }

  int onDragMoreThanWidthX(int index,double xBlankPlace,double dragPointX){
    int x;
    if (dragPointX < 0.0) {
      x=(dragPointX+xBlankPlace)~/(itemWidthChild+xBlankPlace);
      x=x-1;
    } else {
      x=(dragPointX-xBlankPlace)~/(itemWidthChild+xBlankPlace);
      x=x+1;
    }
    return x;
  }

  int onDragLessThanWidthY(int index,double dragPointY){
    int y;
    int a=itemPositions.indexOf(index);
    if(index~/4==a~/4){
      return index;
    }
    if(dragPointY<0.0){
      y=index-crossAxisCount;
    }else{
      y=index+crossAxisCount;
    }
    return y;
  }

  int onDragMoreThanWidthY(int index,double yBlankPlace,double dragPointY){
    int y;
    if(dragPointY<0.0){
      y=index+(dragPointY+yBlankPlace)~/(itemHeightChild+yBlankPlace)*crossAxisCount;
      y=y-crossAxisCount;
    }else{
      y=index+(dragPointY-yBlankPlace)~/(itemHeightChild+yBlankPlace)*crossAxisCount;
      y=y+crossAxisCount;
    }
    return y;
  }


  void onFingerPause(int index,double dragPointX,double dragPointY,DragUpdateDetails updateDetail) async{
    double xBlankPlace=theMarginsOfParentWid*2+crossAxisSpacing;
    double yBlankPlace=theMarginsOfParentHei*2+crossAxisSpacing;

    double xMaxCoverageArea=itemWidthChild*(1-areaCoverageRatio)+itemWidthChild;
    double xMinCoverageArea=itemWidthChild*areaCoverageRatio;
    double yMaxCoverageArea=itemHeightChild*(1-areaCoverageRatio)+itemHeightChild;
    double yMinCoverageArea=itemHeightChild*areaCoverageRatio;

    ////X轴的距离至少被拖动到相邻Item上时
    bool xAtLeastToAdjacentItem=dragPointX.abs()>xBlankPlace;
    bool yAtLeastToAdjacentItem=dragPointY.abs()>yBlankPlace;

    //X轴的拖动距离大于1/3Width 且小于2/3Width
    bool xTransferAbleIfLessThanW=dragPointX.abs()>xMinCoverageArea
        &&dragPointX.abs()<xMaxCoverageArea;
    bool yTransferAbleIfLessThanH=dragPointY.abs()>yMinCoverageArea
        &&dragPointY.abs()<yMaxCoverageArea;

    //X轴的距离至少被拖动到相邻Item上时，并求得是否在某个Item上
    bool xTransferAbleIfMoreThanW=xAtLeastToAdjacentItem
        &&(dragPointX.abs()-xBlankPlace)%(itemWidthChild+xBlankPlace)>xMinCoverageArea
        &&(dragPointX.abs()-xBlankPlace)%(itemWidthChild+xBlankPlace)<xMaxCoverageArea;
    bool yTransferAbleIfMoreThanH=yAtLeastToAdjacentItem
        &&(dragPointY.abs()-yBlankPlace)%(itemHeightChild+yBlankPlace)>yMinCoverageArea
        &&(dragPointY.abs()-yBlankPlace)%(itemHeightChild+yBlankPlace)<yMaxCoverageArea;

    if(xTransferAbleIfLessThanW||yTransferAbleIfLessThanH||xTransferAbleIfMoreThanW||yTransferAbleIfMoreThanH){
      int y=0;
      int x=0;

      if(yTransferAbleIfLessThanH&&yAtLeastToAdjacentItem){
        if(dragPointY>0){
          //item在下侧
          if(updateDetail.delta.dy>0){
            //向下滑
            y=onDragMoreThanWidthY(index,yBlankPlace,dragPointY);
          }else{
            //向上滑
            y=onDragLessThanWidthY(index,dragPointY);
          }
        }else{
          //item在上侧
          if(updateDetail.delta.dy>0){
            //向下滑
            y=onDragLessThanWidthY(index,dragPointY);
          }else{
            //向上滑
            y=onDragMoreThanWidthY(index,yBlankPlace,dragPointY);
          }
        }
      }else if(yTransferAbleIfLessThanH){
        y=onDragLessThanWidthY(index,dragPointY);
      }else if(yTransferAbleIfMoreThanH){
        y=onDragMoreThanWidthY(index,yBlankPlace,dragPointY);
      }


      if(xTransferAbleIfLessThanW&&xAtLeastToAdjacentItem){
        //这里要判断最后一次是滑向哪个方向,先根据dragPointX判断是在左边还是右边，再根据delta.dx判断是左滑还是右滑
        if(dragPointX>0){
          //item在右侧
          if(updateDetail.delta.dx>0){
            //向右滑
            x=onDragMoreThanWidthX(index,xBlankPlace,dragPointX);
          }else{
            //向左滑
            x=onDragLessThanWidthX(index,dragPointX,yTransferAbleIfLessThanH||yTransferAbleIfMoreThanH);
          }
        }else{
          //item在左侧
          if(updateDetail.delta.dx>0){
            //向右滑
            x=onDragLessThanWidthX(index,dragPointX,yTransferAbleIfLessThanH||yTransferAbleIfMoreThanH);
          }else{
            //向左滑
            x=onDragMoreThanWidthX(index,xBlankPlace,dragPointX);
          }
        }
      }else if(xTransferAbleIfLessThanW){
        x=onDragLessThanWidthX(index,dragPointX,yTransferAbleIfLessThanH||yTransferAbleIfMoreThanH);
      }else if(xTransferAbleIfMoreThanW){
        x=onDragMoreThanWidthX(index,xBlankPlace,dragPointX);
      }

      if(endPosition!=x+y&&!controller.isAnimating&&x+y<itemBins.length&&x+y>=0){
        endPosition=x+y;
        controller.forward();
        print("******endPosition $endPosition******x$x********y$y");
      }
    }
  }


  void onPanEndEvent(index)async {
    if(controller.isAnimating){
      await Future.delayed(new Duration(milliseconds: 300));
    }
    setState(() {
      itemBins[index].dragAble=false;
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

  @override
  String toString() {
    return 'ItemBin{data: $data, dragPointX: $dragPointX, dragPointY: $dragPointY, lastTimePositionX: $lastTimePositionX, lastTimePositionY: $lastTimePositionY, containerKey: $containerKey, containerKeyChild: $containerKeyChild, isLongPress: $isLongPress, dragAble: $dragAble}';
  }

}