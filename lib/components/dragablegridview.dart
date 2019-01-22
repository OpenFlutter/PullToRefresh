import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterapp/bin/dragablegridviewbin.dart';

typedef CreateChild = Widget Function(int position);
typedef EditChangeListener();

///准备修改的大纲：3.要适配2-3个文字
class DragAbleGridView <T extends DragAbleGridViewBin> extends StatefulWidget{

  final CreateChild child;
  final List<T> itemBins;
  final int crossAxisCount;
  ///为了便于计算 Item之间的空隙都用crossAxisSpacing
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  //cross-axis to the main-axis
  final double childAspectRatio;
  final EdgeInsets itemPadding;
  final Decoration decoration;
  final double deleteIconSize;
  final double deleteIconMarginTopAndRight;
  final String deleteIconName;
  final EditSwitchController editSwitchController;
  final EditChangeListener editChangeListener;


  DragAbleGridView({
    @required this.child,
    @required this.itemBins,
    this.crossAxisCount:4,
    this.childAspectRatio:1.0,
    this.mainAxisSpacing:0.0,
    this.crossAxisSpacing:0.0,
    this.itemPadding,
    this.decoration,
    this.deleteIconSize:15,
    this.deleteIconMarginTopAndRight:0,
    this.deleteIconName,
    this.editSwitchController,
    this.editChangeListener,
  }) :assert(
  child!=null,
  itemBins!=null,
  );

  @override
  State<StatefulWidget> createState() {
    return new DragAbleGridViewState<T>();
  }
}

class  DragAbleGridViewState <T extends DragAbleGridViewBin> extends State<DragAbleGridView> with SingleTickerProviderStateMixin{

  var physics=new ScrollPhysics();
  double screenWidth;
  double screenHeight;
  //在拖动过程中Item position 的位置记录
  List<int> itemPositions;

  //下面4个变量具体看onTapDown（）方法里面的代码，有具体的备注
  double itemWidth;
  double itemHeight;

  double itemWidthChild;
  double itemHeightChild;

  //下面2个变量具体看onTapDown（）方法里面的代码，有具体的备注
  double theMarginsOfParentWid;
  double theMarginsOfParentHei;

  Animation<double> animation;
  AnimationController controller;

  int startPosition;
  int endPosition;

  bool isRest=false;

  double areaCoverageRatio=2/5;

  Timer timer;
  bool isRemoveItem=false;
  bool isHideDeleteIcon=true;


  @override
  void initState() {
    super.initState();

    widget.editSwitchController.dragAbleGridViewState=this;
    controller = new AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    animation = new Tween(begin:0.0,end: 1.0).animate(controller)
      ..addListener(() {
        if(isRest){
          if(startPosition>endPosition){
            for(int i=endPosition; i<startPosition;i++){
              //图标向右 下移动
              if((i+1)%widget.crossAxisCount==0){
                widget.itemBins[itemPositions[i]].lastTimePositionX = -(screenWidth-itemWidth ) * 1+widget.itemBins[itemPositions[i]].lastTimePositionX;
                widget.itemBins[itemPositions[i]].lastTimePositionY = (itemHeight + widget.mainAxisSpacing) * 1+widget.itemBins[itemPositions[i]].lastTimePositionY ;
              }else {
                widget.itemBins[itemPositions[i]].lastTimePositionX = (itemWidth + widget.crossAxisSpacing) * 1+widget.itemBins[itemPositions[i]].lastTimePositionX ;
              }
            }
          }else{
            for(int i=startPosition+1;i<=endPosition;i++){
              //图标向左 上移动
              if(i%widget.crossAxisCount==0){
                widget.itemBins[itemPositions[i]].lastTimePositionX = (screenWidth-itemWidth ) * 1+widget.itemBins[itemPositions[i]].lastTimePositionX;
                widget.itemBins[itemPositions[i]].lastTimePositionY = -(itemHeight + widget.mainAxisSpacing) * 1+widget.itemBins[itemPositions[i]].lastTimePositionY;
              }else{
                widget.itemBins[itemPositions[i]].lastTimePositionX = -(itemWidth + widget.crossAxisSpacing) * 1+widget.itemBins[itemPositions[i]].lastTimePositionX;
              }
            }
          }
          return;
        }
        setState(() {

          if(startPosition>endPosition){
            for(int i=endPosition; i<startPosition;i++){
              //图标向右 下移动
              if((i+1)%widget.crossAxisCount==0){
                widget.itemBins[itemPositions[i]].dragPointX = -(screenWidth-itemWidth ) * animation.value+widget.itemBins[itemPositions[i]].lastTimePositionX;
                widget.itemBins[itemPositions[i]].dragPointY = (itemHeight + widget.mainAxisSpacing) * animation.value+widget.itemBins[itemPositions[i]].lastTimePositionY ;
              }else {
                widget.itemBins[itemPositions[i]].dragPointX = (itemWidth + widget.crossAxisSpacing) * animation.value+widget.itemBins[itemPositions[i]].lastTimePositionX ;
              }
            }
          }else{
            for(int i=startPosition+1;i<=endPosition;i++){
              //图标向左 上移动
              if(i%widget.crossAxisCount==0){
                widget.itemBins[itemPositions[i]].dragPointX = (screenWidth-itemWidth ) * animation.value+widget.itemBins[itemPositions[i]].lastTimePositionX;
                widget.itemBins[itemPositions[i]].dragPointY = -(itemHeight + widget.mainAxisSpacing) * animation.value+widget.itemBins[itemPositions[i]].lastTimePositionY;
              }else{
                widget.itemBins[itemPositions[i]].dragPointX = -(itemWidth + widget.crossAxisSpacing) * animation.value+widget.itemBins[itemPositions[i]].lastTimePositionX;
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

        if(isRemoveItem){
          isRemoveItem=false;
          itemPositions.removeAt(startPosition);
          onPanEndEvent(startPosition);
        }else{
          int dragPosition=itemPositions[startPosition];
          itemPositions.removeAt(startPosition);
          itemPositions.insert(endPosition, dragPosition);
          //手指未抬起来（可能会继续拖动），这时候end的位置等于Start的位置
          startPosition=endPosition;
        }
      }else if(animationStatus==AnimationStatus.forward){

      }
    });

    _initItemPositions();
  }

  void _initItemPositions(){
    itemPositions=new List();
    for(int i=0;i<widget.itemBins.length;i++){
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
    if(widget.itemBins[index].isLongPress){
      setState(() {
        widget.itemBins[index].dragAble=true;
        startPosition=index;
        if(widget.editChangeListener!=null&&isHideDeleteIcon==true){
          widget.editChangeListener();
        }
        isHideDeleteIcon=false;

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new NotificationListener(
        onNotification: (onNotifications){

        },
        child: new GridView.builder(
            physics: physics,
            scrollDirection: Axis.vertical,
            itemCount: widget.itemBins.length,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: widget.crossAxisCount,childAspectRatio: widget.childAspectRatio,crossAxisSpacing: widget.crossAxisSpacing,mainAxisSpacing: widget.mainAxisSpacing),
            itemBuilder: (BuildContext contexts,int index){
              return new GestureDetector(
                onTapDown: (detail){
                  handleOnTapDownEvent(index,detail);
                },
                onPanUpdate: (updateDetail){
                  handleOnPanUpdateEvent(index,updateDetail);
                },
                onPanEnd: (upDetail){
                  handleOnPanEndEvent(index);
                },
                onTapUp: (tapUpDetails){
                  widget.itemBins[index].isLongPress=false;
                },
                child:new Offstage(
                  offstage: widget.itemBins[index].offstage,
                  child: new Container(
                    alignment: Alignment.center,
                    //color: Colors.grey,
                    key: widget.itemBins[index].containerKey,
                    child: new OverflowBox(
                        maxWidth: screenWidth,
                        maxHeight: screenHeight,
                        alignment: Alignment.center,
                        child: new Center(
                          child: new Container(
                            key: widget.itemBins[index].containerKeyChild,
                            transform: new Matrix4.translationValues(widget.itemBins[index].dragPointX, widget.itemBins[index].dragPointY, 0.0),
                            child: new Stack(
                              alignment: Alignment.topRight,
                              children: <Widget>[
                                new Container(
                                  padding: widget.itemPadding,
                                  decoration: widget.decoration,
                                  margin: EdgeInsets.only(top: widget.deleteIconMarginTopAndRight,right: widget.deleteIconMarginTopAndRight),
                                  child: widget.child(index),
                                ),
                                new Offstage(
                                  offstage: isHideDeleteIcon,
                                  child: new GestureDetector(
                                    child: new Builder(builder: (BuildContext context){
                                      if(widget.deleteIconName!=null){
                                        return new Image.asset(widget.deleteIconName,width: widget.deleteIconSize,height: widget.deleteIconSize,);
                                      }else{
                                        return new Container();
                                      }
                                    }),
                                    onTap: () {
                                      setState(() {
                                        widget.itemBins[index].offstage=true;
                                      });
                                      startPosition=index;
                                      endPosition=widget.itemBins.length-1;
                                      getWidgetsSize(index);
                                      isRemoveItem=true;
                                      _future=controller.forward();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                    ),
                  ),
                ),
              );
            })
    );
  }


  void handleOnPanEndEvent(int index){
    widget.itemBins[index].isLongPress=false;
    if(!widget.itemBins[index].dragAble) {
      widget.itemBins[index].dragPointY = 0.0;
      widget.itemBins[index].dragPointX = 0.0;
    }else {
      onPanEndEvent(index);
    }
  }


  void handleOnPanUpdateEvent(int index,DragUpdateDetails updateDetail){
    widget.itemBins[index].isLongPress=false;
    if(widget.itemBins[index].dragAble) {
      double dragPointY=widget.itemBins[index].dragPointY += updateDetail.delta.dy;
      double dragPointX=widget.itemBins[index].dragPointX += updateDetail.delta.dx;
      if(timer!=null&&timer.isActive){
        timer.cancel();
      }
      if(controller.isAnimating){
        return;
      }
      timer=new Timer(new Duration(milliseconds: 100), (){
        onFingerPause(index,dragPointX,dragPointY,updateDetail);
      });

      setState(() {});
    }
  }


  void handleOnTapDownEvent(int index,TapDownDetails detail){
    getWidgetsSize(index);

    if(!isHideDeleteIcon) {
      //获取控件在屏幕中的y坐标
      double ss = widget.itemBins[index].containerKey.currentContext
          .findRenderObject()
          .getTransformTo(null)
          .getTranslation()
          .y;
      double aa = widget.itemBins[index].containerKey.currentContext
          .findRenderObject()
          .getTransformTo(null)
          .getTranslation()
          .x;

      //计算手指点下去后，控件应该偏移多少像素
      widget.itemBins[index].dragPointY =
          detail.globalPosition.dy - ss - itemHeight / 2;
      widget.itemBins[index].dragPointX =
          detail.globalPosition.dx - aa - itemWidth / 2;
    }

    //标识长按事件开始
    widget.itemBins[index].isLongPress=true;
    //将可拖动标识置为false；（dragAble 为 true时 控件可拖动 ，暂时置为false  等达到长按时间才视为需要拖动）
    widget.itemBins[index].dragAble=false;
    endPosition=index;
    _handLongPress(index);
  }


  void getWidgetsSize(int index){
    //获取 不 带边框的Container的宽度
    itemWidth=widget.itemBins[index].containerKey.currentContext.findRenderObject().paintBounds.size.width;
    itemHeight=widget.itemBins[index].containerKey.currentContext.findRenderObject().paintBounds.size.height;

    //获取  带边框 的Container的宽度，就是可见的Item视图的宽度
    itemWidthChild=widget.itemBins[index].containerKeyChild.currentContext.findRenderObject().paintBounds.size.width;
    itemHeightChild=widget.itemBins[index].containerKeyChild.currentContext.findRenderObject().paintBounds.size.height;

    //获取 不带边框  和它的子View （带边框 的Container）左右两边的空白部分的宽度
    theMarginsOfParentWid=(itemWidth-itemWidthChild)/2;
    theMarginsOfParentHei=(itemHeight-itemHeightChild)/2;
  }


  int onDragLessThanWidthX(int index,double dragPointX,bool isYDragable,DragUpdateDetails updateDetail){
    int x=0;

    int a=itemPositions.indexOf(index);
    if((index==a||isYDragable)||(index!=a||!isYDragable)){
      return 0;
    }
    if (dragPointX < 0.0&&updateDetail.delta.dx>0.0) {
      x=-1;
    } else if(dragPointX > 0.0&&updateDetail.delta.dx<0.0){
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

  int onDragLessThanWidthY(int index,double dragPointY,DragUpdateDetails updateDetail){
    int y=index;
    int a=itemPositions.indexOf(index);
    if(index~/widget.crossAxisCount==a~/widget.crossAxisCount){
      return index;
    }
    if(dragPointY<0.0&&updateDetail.delta.dy>0.0){
      y=index-widget.crossAxisCount;
    }else if(dragPointY>0.0&&updateDetail.delta.dy<0.0){
      y=index+widget.crossAxisCount;
    }
    return y;
  }

  int onDragMoreThanWidthY(int index,double yBlankPlace,double dragPointY){
    int y;
    if(dragPointY<0.0){
      y=index+(dragPointY+yBlankPlace)~/(itemHeightChild+yBlankPlace)*widget.crossAxisCount;
      y=y-widget.crossAxisCount;
    }else{
      y=index+(dragPointY-yBlankPlace)~/(itemHeightChild+yBlankPlace)*widget.crossAxisCount;
      y=y+widget.crossAxisCount;
    }
    return y;
  }


  void onFingerPause(int index,double dragPointX,double dragPointY,DragUpdateDetails updateDetail) async{
    double xBlankPlace=theMarginsOfParentWid*2+widget.crossAxisSpacing;
    double yBlankPlace=theMarginsOfParentHei*2+widget.mainAxisSpacing;

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
            y=onDragLessThanWidthY(index,dragPointY,updateDetail);
          }
        }else{
          //item在上侧
          if(updateDetail.delta.dy>0){
            //向下滑
            y=onDragLessThanWidthY(index,dragPointY,updateDetail);
          }else{
            //向上滑
            y=onDragMoreThanWidthY(index,yBlankPlace,dragPointY);
          }
        }
      }else if(yTransferAbleIfLessThanH){
        y=onDragLessThanWidthY(index,dragPointY,updateDetail);
      }else if(yTransferAbleIfMoreThanH){
        y=onDragMoreThanWidthY(index,yBlankPlace,dragPointY);
      }else if(yAtLeastToAdjacentItem
          &&((dragPointY.abs()-yBlankPlace)%(itemHeightChild+yBlankPlace)<yMinCoverageArea
              ||(dragPointY.abs()-yBlankPlace)%(itemHeightChild+yBlankPlace)>yMaxCoverageArea)){
        //TODO 还有一种情况就是 ，X轴可移动，Y轴不可移动(Y轴小于1/5的高度，或大于4/5的高度)，但是Y轴有高度，这时要将Y轴的高度算上
        y=onDragMoreThanWidthY(index,yBlankPlace,dragPointY);
      }else{
        //要考虑到一种情况，就是只有X轴可移动，Y轴不可移动，这时
        y=index;
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
            x=onDragLessThanWidthX(index,dragPointX,yTransferAbleIfLessThanH||yTransferAbleIfMoreThanH,updateDetail);
          }
        }else{
          //item在左侧
          if(updateDetail.delta.dx>0){
            //向右滑
            x=onDragLessThanWidthX(index,dragPointX,yTransferAbleIfLessThanH||yTransferAbleIfMoreThanH,updateDetail);
          }else{
            //向左滑
            x=onDragMoreThanWidthX(index,xBlankPlace,dragPointX);
          }
        }
      }else if(xTransferAbleIfLessThanW){
        x=onDragLessThanWidthX(index,dragPointX,yTransferAbleIfLessThanH||yTransferAbleIfMoreThanH,updateDetail);
      }else if(xTransferAbleIfMoreThanW){
        x=onDragMoreThanWidthX(index,xBlankPlace,dragPointX);
      }else if(xAtLeastToAdjacentItem&&
          ((dragPointX.abs()-xBlankPlace)%(itemWidthChild+xBlankPlace)>xMinCoverageArea
              ||(dragPointX.abs()-xBlankPlace)%(itemWidthChild+xBlankPlace)<xMaxCoverageArea)){
        //TODO 还有一种情况就是 ，X轴不可移动(X轴小于1/5的宽度，或大于4/5的宽度)，Y轴可移动，但是X轴有宽度，这时要将X轴的宽度算上
        x=onDragMoreThanWidthX(index,xBlankPlace,dragPointX);
      }

      if(endPosition!=x+y
          &&!controller.isAnimating
          &&x+y<widget.itemBins.length
          &&x+y>=0
          &&widget.itemBins[index].dragAble){
        endPosition=x+y;
        _future=controller.forward();
      }
    }
  }

  Future _future;

  void onPanEndEvent(index)async {
    widget.itemBins[index].dragAble=false;
    if(controller.isAnimating){
      await _future;
    }
    setState(() {
      List<T> itemBi = new List();
      T bin;
      for (int i = 0; i < itemPositions.length; i++) {
        bin=widget.itemBins[itemPositions[i]];
        bin.dragPointX = 0.0;
        bin.dragPointY = 0.0;
        bin.lastTimePositionX = 0.0;
        bin.lastTimePositionY = 0.0;
        itemBi.add(bin);
      }
      widget.itemBins.clear();
      widget.itemBins.addAll(itemBi);
      _initItemPositions();
    });
  }

  void changeDeleteIconState(){
    setState(() {
      isHideDeleteIcon=!isHideDeleteIcon;
    });
  }
}

class EditSwitchController{
  DragAbleGridViewState dragAbleGridViewState;

  void editStateChanged(){
    dragAbleGridViewState.changeDeleteIconState();
  }
}

