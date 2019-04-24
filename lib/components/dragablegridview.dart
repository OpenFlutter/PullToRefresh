import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterapp/bin/dragablegridviewbin.dart';

typedef CreateChild = Widget Function(int position);
typedef EditChangeListener();

///准备修改的大纲：3.要适配2-3个文字
class DragAbleGridView <T extends DragAbleGridViewBin> extends StatefulWidget{

  final CreateChild child;
  final List<T> itemBins;
  ///GridView一行显示几个child
  final int crossAxisCount;
  ///为了便于计算 Item之间的空隙都用crossAxisSpacing
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  //cross-axis to the main-axis
  final double childAspectRatio;
  ///编辑开关控制器，可通过点击按钮触发编辑
  final EditSwitchController editSwitchController;
  ///长按触发编辑状态，可监听状态来改变编辑按钮（编辑开关 ，通过按钮触发编辑）的状态
  final EditChangeListener editChangeListener;
  final bool isOpenDragAble;
  final int animationDuration;
  final int longPressDuration;
  ///删除按钮
  final Widget deleteIcon;


  DragAbleGridView({
    @required this.child,
    @required this.itemBins,
    this.crossAxisCount:4,
    this.childAspectRatio:1.0,
    this.mainAxisSpacing:0.0,
    this.crossAxisSpacing:0.0,
    this.editSwitchController,
    this.editChangeListener,
    this.isOpenDragAble:false,
    this.animationDuration:300,
    this.longPressDuration:800,
    this.deleteIcon,
  }) :assert(
  child!=null,
  itemBins!=null,
  );

  @override
  State<StatefulWidget> createState() {
    return new DragAbleGridViewState<T>();
  }
}

class  DragAbleGridViewState <T extends DragAbleGridViewBin> extends State<DragAbleGridView> with SingleTickerProviderStateMixin implements DragAbleViewListener{

  var physics=new ScrollPhysics();
  double screenWidth;
  double screenHeight;
  ///在拖动过程中Item position 的位置记录
  List<int> itemPositions;
  ///下面4个变量具体看onTapDown（）方法里面的代码，有具体的备注
  double itemWidth = 0.0;
  double itemHeight = 0.0;
  double itemWidthChild = 0.0;
  double itemHeightChild = 0.0;
  ///下面2个变量具体看onTapDown（）方法里面的代码，有具体的备注
  double blankSpaceHorizontal = 0.0;
  double blankSpaceVertical = 0.0;
  double xBlankPlace = 0.0;
  double yBlankPlace = 0.0;

  Animation<double> animation;
  AnimationController controller;
  int startPosition;
  int endPosition;
  bool isRest=false;
  ///覆盖超过1/5则触发动画，宽和高只要有一个满足就可以触发
  //double areaCoverageRatio=1/5;
  Timer timer;
  bool isRemoveItem=false;
  bool isHideDeleteIcon=true;
  Future _future;
  double xyDistance = 0.0;
  double yDistance = 0.0;
  double xDistance = 0.0;



  @override
  void initState() {
    super.initState();
    widget.editSwitchController.dragAbleGridViewState=this;
    controller = new AnimationController(duration:  Duration(milliseconds : widget.animationDuration), vsync: this);
    animation = new Tween(begin:0.0,end: 1.0).animate(controller)
      ..addListener(() {
        T offsetBin;
        int childWidgetPosition;

        if(isRest){
          if(startPosition>endPosition){
            for(int i=endPosition; i<startPosition;i++){
              childWidgetPosition=itemPositions[i];
              offsetBin=widget.itemBins[childWidgetPosition];
              //图标向右 下移动
              if((i+1)%widget.crossAxisCount==0){
                offsetBin.lastTimePositionX = -(screenWidth-itemWidth ) * 1+offsetBin.lastTimePositionX;
                offsetBin.lastTimePositionY = (itemHeight + widget.mainAxisSpacing) * 1+offsetBin.lastTimePositionY ;
              }else {
                offsetBin.lastTimePositionX = (itemWidth + widget.crossAxisSpacing) * 1+offsetBin.lastTimePositionX ;
              }
            }
          }else{
            for(int i=startPosition+1;i<=endPosition;i++){
              childWidgetPosition=itemPositions[i];
              offsetBin=widget.itemBins[childWidgetPosition];
              //图标向左 上移动
              if(i%widget.crossAxisCount==0){
                offsetBin.lastTimePositionX = (screenWidth-itemWidth ) * 1+offsetBin.lastTimePositionX;
                offsetBin.lastTimePositionY = -(itemHeight + widget.mainAxisSpacing) * 1+offsetBin.lastTimePositionY;
              }else{
                offsetBin.lastTimePositionX = -(itemWidth + widget.crossAxisSpacing) * 1+offsetBin.lastTimePositionX;
              }
            }
          }
          return;
        }
        double animationValue = animation.value;

        //此代码和上面的代码一样，但是不能提成方法调用 ，已经测试调用方法不会生效
        //startPosition大于endPosition表明目标位置在上方，图标需要向后退一格
        if(startPosition>endPosition){
          for(int i=endPosition; i<startPosition;i++){
            childWidgetPosition=itemPositions[i];
            offsetBin=widget.itemBins[childWidgetPosition];
            //图标向左 下移动；如果图标处在最右侧，那需要向下移动一层，移动到下一层的最左侧，（开头的地方）
            if((i+1)%widget.crossAxisCount==0){
              setState(() {
                offsetBin.dragPointX = -xyDistance * animationValue+offsetBin.lastTimePositionX;
                offsetBin.dragPointY = yDistance * animationValue+offsetBin.lastTimePositionY ;
              });
            }else {
              setState(() {
                //↑↑↑如果图标不是处在最右侧，只需要向右移动即可
                offsetBin.dragPointX = xDistance * animationValue+offsetBin.lastTimePositionX ;
              });
            }
          }
        }
        //当目标位置在下方时 ，图标需要向前前进一个
        else{
          for(int i=startPosition+1;i<=endPosition;i++){
            childWidgetPosition=itemPositions[i];
            offsetBin=widget.itemBins[childWidgetPosition];
            //图标向右 上移动；如果图标处在最左侧，那需要向上移动一层
            if(i%widget.crossAxisCount==0){
              setState(() {
                offsetBin.dragPointX = xyDistance * animationValue+offsetBin.lastTimePositionX;
                offsetBin.dragPointY = -yDistance * animationValue+offsetBin.lastTimePositionY;
              });
            }else{
              setState(() {
                //↑↑↑如果图标不是处在最左侧，只需要向左移动即可
                offsetBin.dragPointX = -xDistance * animationValue+offsetBin.lastTimePositionX;
              });
            }
          }
        }
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
  void didUpdateWidget(DragAbleGridView<DragAbleGridViewBin> oldWidget) {
    if(itemPositions.length!= widget.itemBins.length){
      _initItemPositions();
    }
    super.didUpdateWidget(oldWidget);
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Size screenSize=MediaQuery.of(context).size;
    screenWidth=screenSize.width;
    screenHeight=screenSize.height;
  }


  ///自定义长按事件，只有长按800毫秒 才能触发拖动
  void _handLongPress(int index) async{
    await Future.delayed(new Duration(milliseconds: widget.longPressDuration));
    if(widget.itemBins[index].isLongPress){
      widget.itemBins[index].dragAble=true;
      startPosition=index;
      if(widget.editChangeListener!=null&&isHideDeleteIcon==true){
        widget.editChangeListener();
      }
      isHideDeleteIcon=false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new GridView.builder(
      physics: physics,
      scrollDirection: Axis.vertical,
      itemCount: widget.itemBins.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.crossAxisCount,
          childAspectRatio: widget.childAspectRatio,
          crossAxisSpacing: widget.crossAxisSpacing,
          mainAxisSpacing: widget.mainAxisSpacing
      ),
      itemBuilder: (BuildContext contexts,int index){
        return DragAbleContentView(
          isOpenDragAble: widget.isOpenDragAble,
          screenHeight: screenHeight,
          screenWidth: screenWidth,
          isHideDeleteIcon: isHideDeleteIcon,
          controller: controller,
          longPressDuration: widget.longPressDuration,
          index: index,
          dragAbleGridViewBin: widget.itemBins[index],
          dragAbleViewListener: this,
          child: new Stack(
            alignment: Alignment.topRight,
            children: <Widget>[
              widget.child(index),
              new Offstage(
                offstage: isHideDeleteIcon,
                child: new GestureDetector(
                  child: new Builder(builder: (BuildContext context){
                    if(widget.deleteIcon!=null){
                      return widget.deleteIcon;
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
                    getWidgetsSize(widget.itemBins[index]);
                    isRemoveItem=true;
                    _future=controller.forward();
                  },
                ),
              ),
            ],
          ),
        );
      });

  }




  ///如果item的大小都不一样大，那每次拖动前都必须计算item的相关尺寸
  @override
  void getWidgetsSize(DragAbleGridViewBin pressItemBin){
    if(itemWidth == 0) {
      //获取 不 带边框的Container的宽度
      itemWidth = pressItemBin.containerKey.currentContext
          .findRenderObject()
          .paintBounds
          .size
          .width;
    }
    if(itemHeight ==0) {
      itemHeight = pressItemBin.containerKey.currentContext
          .findRenderObject()
          .paintBounds
          .size
          .height;
    }

    if(itemWidthChild==0) {
      //获取  带边框 的Container的宽度，就是可见的Item视图的宽度
      itemWidthChild = pressItemBin.containerKeyChild.currentContext
          .findRenderObject()
          .paintBounds
          .size
          .width;
    }
    if(itemHeightChild==0){
      itemHeightChild = pressItemBin.containerKeyChild.currentContext
          .findRenderObject()
          .paintBounds
          .size
          .height;
    }

    if(blankSpaceHorizontal==0){
      //获取 不带边框  和它的子View （带边框 的Container）左右两边的空白部分的宽度
      blankSpaceHorizontal = (itemWidth - itemWidthChild) / 2;
    }

    if(blankSpaceVertical==0) {
      blankSpaceVertical = (itemHeight - itemHeightChild) / 2;
    }

    if(xBlankPlace==0){
      //边框和父布局之间的空白部分  +  gridView Item之间的space   +  相邻Item边框和父布局之间的空白部分
      //所以 一个View和相邻View空白的部分计算如下 ，也就是说大于这个值 两个Item则能相遇叠加
      xBlankPlace = blankSpaceHorizontal * 2 + widget.crossAxisSpacing;
    }

    if(yBlankPlace==0) {
      yBlankPlace = blankSpaceVertical * 2 + widget.mainAxisSpacing;
    }

    if(xyDistance == 0){
      xyDistance = screenWidth-itemWidth;
    }

    if(yDistance == 0){
      yDistance = itemHeight + widget.mainAxisSpacing;
    }

    if(xDistance == 0){
      xDistance = itemWidth + widget.crossAxisSpacing;
    }
  }


  int geyXTransferItemCount(int index,double xBlankPlace,double dragPointX){

    //最大边界 和 最小边界
    //double maxBoundWidth = itemWidthChild * (1-areaCoverageRatio);
    //double minBoundWidth = itemWidthChild * areaCoverageRatio;

    //是否越过空白间隙，未越过则表示在原地，或覆盖自己原位置的一部分，未拖动到其他Item上，或者已经拖动过多次现在又拖回来了；越过则有多种情况
    if(dragPointX.abs()>xBlankPlace){
      if(dragPointX>0){
        //↑↑↑表示移动到自己原位置的右手边
        return checkXAxleRight(index,xBlankPlace,dragPointX);
      }else{
        //↑↑↑表示移动到自己原位置的左手边
        return checkXAxleLeft(index,xBlankPlace,dragPointX);
      }
    }else{
      //↑↑↑连一个空白的区域都未越过 肯定是呆在自己的原位置，返回index
      return 0;
    }
  }

  ///当被拖动到自己位置右侧时
  int checkXAxleRight(int index,double xBlankPlace,double dragPointX){
    double aSection=xBlankPlace+itemWidthChild;

    double rightTransferDistance=dragPointX.abs()+itemWidthChild;
    //计算左右边框的余数
    double rightBorder=rightTransferDistance%aSection;
    double leftBorder=dragPointX.abs()%aSection;

    //与2个item有粘连时，计算占比多的就是要目标位置
    if(rightBorder<itemWidthChild&&leftBorder<itemWidthChild){
      if(itemWidthChild-leftBorder>rightBorder){
        //left占比多，那左侧未将要动画的目标位置
        return (dragPointX.abs()/aSection).floor();
      }else{
        //right占比多
        return (rightTransferDistance/aSection).floor();
      }

    }else if (rightBorder>itemWidthChild&&leftBorder<itemWidthChild) {
      //left粘连，右边的边框在空白区域
      return (dragPointX.abs()/aSection).floor();
    }else if (rightBorder<itemWidthChild&&leftBorder>itemWidthChild) {
      //right粘连，左侧的边框在空白区域
      return (rightTransferDistance/aSection).floor();
    }else {
      //左右两边均没有粘连时，说明左右两边处于空白区域，返回0即可
      return 0;
    }
  }

  ///X轴方向上，当被拖动到自己位置左侧时
  int checkXAxleLeft(int index,double xBlankPlace,double dragPointX){
    double aSection=xBlankPlace+itemWidthChild;

    double leftTransferDistance=dragPointX.abs()+itemWidthChild;

    //计算左右边框的余数
    double leftBorder=leftTransferDistance%aSection;
    double rightBorder=dragPointX.abs()%aSection;

    //与2个item有粘连时，计算占比多的就是要目标位置
    if(rightBorder<itemWidthChild&&leftBorder<itemWidthChild){
      if(itemWidthChild-rightBorder>leftBorder){
        //right占比多，那右侧为将要动画的目标位置
        return -(dragPointX.abs()/aSection).floor();
      }else{
        //left占比多
        return -(leftTransferDistance/aSection).floor();
      }

    }else if (rightBorder>itemWidthChild&&leftBorder<itemWidthChild) {
      //left粘连，右边的边框在空白区域
      return -(leftTransferDistance/aSection).floor();

    }else if (rightBorder<itemWidthChild&&leftBorder>itemWidthChild) {
      //right粘连，左侧的边框在空白区域
      return -(dragPointX.abs()/aSection).floor();

    }else {
      //左右两边均没有粘连时，说明左右两边处于空白区域，返回0即可
      return 0;
    }
  }



  ///计算Y轴方向需要移动几个Item
  /// 1. 目标拖动距离拖动不满足， 2. 拖动到其他Item的，3. 和任何Item都没有粘连，5.和多个item有重叠 等4种情况
  /// 还要考虑一点就是 虽然Y轴不满足1/5--4/5覆盖率，但是X轴满足
  int geyYTransferItemCount(int index,double yBlankPlace,double dragPointY){

    //最大边界 和 最小边界
    //double maxBoundHeight = itemHeightChild * (1-areaCoverageRatio);
    //double minBoundHeight = itemHeightChild * areaCoverageRatio;

    //上下边框是否都满足 覆盖1/5--4/5高度的要求
    //bool isTopBoundLegitimate = topBorder > minBoundHeight && topBorder < maxBoundHeight;
    //bool isBottomBoundLegitimate = bottomBorder > minBoundHeight && bottomBorder < maxBoundHeight;

    //是否越过空白间隙，未越过则表示在原地，或覆盖自己原位置的一部分，未拖动到其他Item上，或者已经拖动过多次现在又拖回来了；越过则有多种情况
    if(dragPointY.abs()>yBlankPlace){
      //↑↑↑越过则有多种情况↓↓↓
      if(dragPointY>0){
        //↑↑↑表示拖动的Item现在处于原位置之下
        return checkYAxleBelow(index,yBlankPlace,dragPointY);
      }else{
        //↑↑↑表示拖动的Item现在处于原位置之上
        return checkYAxleAbove(index,yBlankPlace,dragPointY);
      }
    }else{
      //↑↑↑未越过 返回index
      return index;
    }
  }


  ///Y轴上当被拖动到原位置之上时，计算拖动了几行
  int checkYAxleAbove(int index,double yBlankPlace,double dragPointY){
    double aSection=yBlankPlace+itemHeightChild;

    double topTransferDistance=dragPointY.abs()+itemHeightChild;

    //求下边框的余数，余数小于itemHeightChild，表示和下面的item覆盖，余数大于itemHeightChild，表示下边框处于空白的区域
    double topBorder = (topTransferDistance)%aSection;
    //求上边框的余数 ，余数小于itemHeightChild，表示和上面的Item覆盖 ，余数大于itemHeightChild，表示上边框处于空白区域
    double bottomBorder = dragPointY.abs()%aSection;

    if(topBorder<itemHeightChild&&bottomBorder<itemHeightChild){
      //↑↑↑同时和2和item覆盖（上下边框均在覆盖区域）
      if(itemHeightChild-bottomBorder>topBorder){
        //↑↑↑粘连2个  要计算哪个占比多,topBorder越小 覆盖面积越大  ，bottomBorder越大  覆盖面积越大;
        //下边框占比叫较大
        return index-(dragPointY.abs()/aSection).floor()*widget.crossAxisCount;
      }else{
        //↑↑↑上边框占比大
        return index-(topTransferDistance/aSection).floor()*widget.crossAxisCount;
      }
    }else if(topBorder>itemHeightChild&&bottomBorder<itemHeightChild){
      //↑↑↑下边框在覆盖区,上边框在空白区域。
      return index-(dragPointY.abs()/aSection).floor()*widget.crossAxisCount;

    }else if(topBorder<itemHeightChild&&bottomBorder>itemHeightChild){
      //↑↑↑上边框在覆盖区域,下边框在空白区域
      return index-(topTransferDistance/aSection).floor()*widget.crossAxisCount;

    }else{
      //和哪个Item都没有覆盖，上下边框都在空白的区域。返回Index即可
      return index;
    }
  }

  /// 还要考虑一点就是 虽然Y轴不满足1/5--4/5覆盖率，但是X轴满足，所以返回的时候同时返回目标index 和 是否满足Y的覆盖条件
  int checkYAxleBelow(int index,double yBlankPlace,double dragPointY){
    double aSection=yBlankPlace+itemHeightChild;

    double bottomTransferDistance=dragPointY.abs()+itemHeightChild;

    //求下边框的余数，余数小于itemHeightChild，表示和下面的item覆盖，余数大于itemHeightChild，表示下边框处于空白的区域
    double bottomBorder = bottomTransferDistance%aSection;
    //求上边框的余数 ，余数小于itemHeightChild，表示和上面的Item覆盖 ，余数大于itemHeightChild，表示上边框处于空白区域
    double topBorder = dragPointY.abs()%aSection;

    if(bottomBorder<itemHeightChild && topBorder<itemHeightChild){
      //↑↑↑同时和2和item覆盖（上下边框均在覆盖区域）
      if(itemHeightChild-topBorder>bottomBorder){
        //↑↑↑粘连2个  要计算哪个占比多,topBorder越小 覆盖面积越大  ，bottomBorder越大  覆盖面积越大;
        //↑↑↑上面占比大
        return index + (dragPointY.abs()/aSection).floor()*widget.crossAxisCount;

      }else{
        //↑↑↑下面占比大
        return index + (bottomTransferDistance/aSection).floor()*widget.crossAxisCount;
      }
    }else if(topBorder>itemHeightChild&&bottomBorder<itemHeightChild){
      //↑↑↑下边框在覆盖区 , 上边框在空白区域
      return index + (bottomTransferDistance/aSection).floor()*widget.crossAxisCount;

    }else if(topBorder<itemHeightChild&&bottomBorder>itemHeightChild){ //topBorder<itemHeightChild
      //↑↑↑上边框在覆盖区域 ,下边框在空白区域
      return index + (dragPointY.abs()/aSection).floor()*widget.crossAxisCount;

    }else{
     //↑↑↑和哪个Item都没有覆盖，上下边框都在空白的区域。返回Index即可
      return index;
    }
  }


  ///停止滑动时，处理是否需要动画等
  @override
  void onFingerPause(int index,double dragPointX,double dragPointY,DragUpdateDetails updateDetail) async{
    int y=geyYTransferItemCount(index,yBlankPlace,dragPointY);
    int x=geyXTransferItemCount(index,xBlankPlace,dragPointX);

    //2.动画正在进行时不能进行动画 3. 计算错误时，终点坐标小于或者大于itemBins.length时不能动画
    if(endPosition!=x+y
        &&!controller.isAnimating
        &&x+y<widget.itemBins.length
        &&x+y>=0
        &&widget.itemBins[index].dragAble){
      endPosition=x+y;
      _future=controller.forward();
    }
  }

  ///拖动结束后，根据 itemPositions 里面的排序，将itemBins重新排序
  ///并重新初始化 itemPositions
  @override
  void onPanEndEvent(index) async{
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

  ///外部使用EditSwitchController控制编辑状态
  ///当调用该方法时 将GridView Item上的删除图标的状态取非 来改变状态
  void changeDeleteIconState(){
    setState(() {
      isHideDeleteIcon=!isHideDeleteIcon;
    });
  }

  @override
  void onTapDown(int index) {
    endPosition=index;
    _handLongPress(index);
  }

  @override
  void calculateOffset(DragAbleGridViewBin pressItemBin, TapDownDetails detail,double pointYInScreen,double pointXInScreen) {
    //计算手指点下去后，控件应该偏移多少像素
    pressItemBin.dragPointY = detail.globalPosition.dy - pointYInScreen - itemHeight / 2;
    pressItemBin.dragPointX = detail.globalPosition.dx - pointXInScreen - itemWidth / 2;
  }
}


class EditSwitchController{
  DragAbleGridViewState dragAbleGridViewState;

  void editStateChanged(){
    dragAbleGridViewState.changeDeleteIconState();
  }
}


class DragAbleContentView<T extends DragAbleGridViewBin> extends StatefulWidget{

  final Widget child;
  final bool isOpenDragAble;
  final double screenWidth,screenHeight;
  final bool isHideDeleteIcon;
  final AnimationController controller;
  final int longPressDuration;
  final int index;
  final T dragAbleGridViewBin;
  final DragAbleViewListener dragAbleViewListener;

  DragAbleContentView({
    @required this.child,
    @required this.isOpenDragAble,
    @required this.screenHeight,
    @required this.screenWidth,
    @required this.isHideDeleteIcon,
    @required this.controller,
    @required this.longPressDuration,
    @required this.index,
    @required this.dragAbleGridViewBin,
    @required this.dragAbleViewListener,
  });

  @override
  State<StatefulWidget> createState() {
    return DragAbleContentViewState<T>();
  }
}


class DragAbleContentViewState<T extends DragAbleGridViewBin> extends State<DragAbleContentView<T>>{

  Timer timer;
  double itemWidth;
  double itemHeight;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTapDown: widget.isOpenDragAble ? (detail){
        handleOnTapDownEvent(detail);
      } : null,
      onPanUpdate: widget.isOpenDragAble ? (updateDetail){
        handleOnPanUpdateEvent(updateDetail);
      } : null,
      onPanEnd: widget.isOpenDragAble ? (upDetail){
        handleOnPanEndEvent(widget.index);
      } : null,
      onTapUp: widget.isOpenDragAble ? (tapUpDetails){
        handleOnTapUp();
      } : null,
      child:new Offstage(
        offstage: widget.dragAbleGridViewBin.offstage,
        child: new Container(
          alignment: Alignment.center,
          //color: Colors.grey,
          key: widget.dragAbleGridViewBin.containerKey,
          child: new OverflowBox(
              maxWidth: widget.screenWidth,
              maxHeight: widget.screenHeight,
              alignment: Alignment.center,
              child: new Center(
                child: new Container(
                  key: widget.dragAbleGridViewBin.containerKeyChild,
                  transform: new Matrix4.translationValues(widget.dragAbleGridViewBin.dragPointX, widget.dragAbleGridViewBin.dragPointY, 0.0),
                  child: widget.child,
                ),
              )
          ),
        ),
      ),
    );
  }



  void handleOnPanEndEvent(int index){
    T pressItemBin = widget.dragAbleGridViewBin;
    pressItemBin.isLongPress=false;
    if(!pressItemBin.dragAble) {
      pressItemBin.dragPointY = 0.0;
      pressItemBin.dragPointX = 0.0;
    }else {
      widget.dragAbleGridViewBin.dragAble=false;
      widget.dragAbleViewListener.onPanEndEvent(index);
    }
  }


  void handleOnTapUp(){
    T pressItemBin = widget.dragAbleGridViewBin;
    pressItemBin.isLongPress=false;
    if(!widget.isHideDeleteIcon) {
      //计算手指点下去后，控件应该偏移多少像素
      pressItemBin.dragPointY = 0.0;
      pressItemBin.dragPointX = 0.0;
    }
  }


  void handleOnPanUpdateEvent(DragUpdateDetails updateDetail){
    T pressItemBin = widget.dragAbleGridViewBin;

    pressItemBin.isLongPress=false;
    if(pressItemBin.dragAble) {
      double dragPointY=pressItemBin.dragPointY += updateDetail.delta.dy;
      double dragPointX=pressItemBin.dragPointX += updateDetail.delta.dx;
      if(timer!=null&&timer.isActive){
        timer.cancel();
      }
      if(widget.controller.isAnimating){
        return;
      }
      timer=new Timer(new Duration(milliseconds: 100), (){
        widget.dragAbleViewListener.onFingerPause(widget.index,dragPointX,dragPointY,updateDetail);
      });
      setState(() {});
    }
  }


  void handleOnTapDownEvent(TapDownDetails detail){
    T pressItemBin = widget.dragAbleGridViewBin;
    widget.dragAbleViewListener.getWidgetsSize(pressItemBin);

    if(!widget.isHideDeleteIcon) {
      //获取控件在屏幕中的y坐标
      double ss = pressItemBin.containerKey.currentContext.findRenderObject().getTransformTo(null).getTranslation().y;
      double aa = pressItemBin.containerKey.currentContext.findRenderObject().getTransformTo(null).getTranslation().x;

      widget.dragAbleViewListener.calculateOffset(pressItemBin,detail,ss,aa);
    }

    //标识长按事件开始
    pressItemBin.isLongPress=true;
    //将可拖动标识置为false；（dragAble 为 true时 控件可拖动 ，暂时置为false  等达到长按时间才视为需要拖动）
    pressItemBin.dragAble=false;
    widget.dragAbleViewListener.onTapDown(widget.index);
  }
}

abstract class DragAbleViewListener<T extends DragAbleGridViewBin>{
  void getWidgetsSize(T pressItemBin);
  void onTapDown(int index);
  void onFingerPause(int index ,double dragPointX,double dragPointY,DragUpdateDetails updateDetail);
  void onPanEndEvent(int index);
  void calculateOffset(T pressItemBin, TapDownDetails detail,double pointYInScreen,double pointXInScreen);
}
