import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterapp/bin/adsorptiondatabin.dart';
import 'package:flutterapp/components/adsorptionview/adsorptionview.dart';

///此控件适用于非固定高度的ListView
class AdsorptionViewNotEqualHeightState<T extends AdsorptionData> extends State<AdsorptionView<T>> implements PositionChangedListener,ViewChangeListener{

  ScrollController scrollController=new ScrollController();
  GlobalKey listViewKey=new GlobalKey();
  double lastTimePix=0.0;
  int memoryPosition =0;

  void saveHeaderPosition(int k,double listViewGlobalPositionY){
    if(widget.adsorptionDatas[k].headerPosition<0){
      var context = widget.adsorptionDatas[k].adsorptionKey.currentContext;
      if(context!=null ) {
        RenderBox renderBox = context.findRenderObject();
        var offsetScreen = renderBox.getTransformTo(null).getTranslation().y;
        widget.adsorptionDatas[k].headerPosition = scrollController.position.pixels + offsetScreen - listViewGlobalPositionY;
        print("${widget.adsorptionDatas[k]}********${widget.adsorptionDatas[k].headerPosition}");
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new ListView.builder(
          key: listViewKey,
          controller: scrollController,
          cacheExtent: widget.cacheExtent,
          itemCount: widget.adsorptionDatas.length,
          itemBuilder: (context, index) {

            if(widget.adsorptionDatas[index].isHeader){
              //返回头部视图
              return new LifeCycleWidget(
                changedListener: this,
                index: index,
                child:new Container(
                  key: widget.adsorptionDatas[index].adsorptionKey,
                  width: widget.itemWidth,
                  child: widget.headChild(widget.adsorptionDatas[index]),
                ),
              );
            }else {
              //返回组成员的视图
              return new LifeCycleWidget(
                index: index,
                changedListener: this,
                child: new Container(
                  key: widget.adsorptionDatas[index].adsorptionKey,
                  width: widget.itemWidth,
                  child: widget.generalItemChild(widget.adsorptionDatas[index]),
                ),
              );
            }
          },
        ),


        new GestureDetector(
          onTap: (){
            double chileGlobalPositionY;
            double chileHeight;

            //获取ListView在屏幕中的位置
            double listViewGlobalPositionY=listViewKey.currentContext.findRenderObject().getTransformTo(null).getTranslation().y;
            for(int i = memoryPosition;i<=widget.adsorptionDatas.length;i++){
              if(widget.adsorptionDatas[i].adsorptionKey.currentContext==null){
                continue;
              }
              //子控件在屏幕中的位置 用于计算第一个可见Item的位置
              chileGlobalPositionY=widget.adsorptionDatas[i].adsorptionKey.currentContext.findRenderObject().getTransformTo(null).getTranslation().y;
              //控件高度 用于计算第一个可见Item的位置
              chileHeight=widget.adsorptionDatas[i].adsorptionKey.currentContext.findRenderObject().paintBounds.size.height;
              //如果在屏幕中可见
              if(chileGlobalPositionY+chileHeight>listViewGlobalPositionY){
                print("第一个可见的item is ${widget.adsorptionDatas[i]}");
                for(int m=i;m>=0;m--){
                  if(widget.adsorptionDatas[m].isHeader) {
                    scrollController.animateTo(widget.adsorptionDatas[m].headerPosition, duration: new Duration(milliseconds: 200), curve: Curves.linear);
                    break;
                  }
                }
                break;
              }
            }
          },
          child: new HeaderView(
            headChild:widget.headChild,
            itemWidth:widget.itemWidth,
            adsorptionDatas: widget.adsorptionDatas,
            scrollController: scrollController,
            viewChangeListener: this,
          ),
        ),
      ],
    );
  }

  @override
  void onWidgetDispose(int index) {
    if(index == memoryPosition){
      memoryPosition ++;
      print("onWidgetDispose memoryPosition is $memoryPosition");
    }
  }

  @override
  void onWidgetInit(int index) {
    if(index<memoryPosition){
      memoryPosition = index;
      print("onWidgetInit memoryPosition is $memoryPosition");
    }
  }

  @override
  GlobalKey<State<StatefulWidget>> getListViewKey() {
    return listViewKey;
  }

  @override
  int getMemoryPosition() {
    return memoryPosition;
  }
}


class HeaderView<T extends AdsorptionData> extends StatefulWidget{

  final double itemWidth;
  final GetHearWidget<T> headChild;
  final ScrollController scrollController;
  final List<T> adsorptionDatas;
  final ViewChangeListener viewChangeListener;

  HeaderView({
    @required this.headChild,
    @required this.itemWidth,
    @required this.scrollController,
    @required this.adsorptionDatas,
    @required this.viewChangeListener,
  });

  @override
  State<StatefulWidget> createState() {
    return HeaderViewState<T>();
  }
}

class HeaderViewState<T extends AdsorptionData> extends State<HeaderView<T>>{

  T headerData;
  double headerOffset=0.0;
  GlobalKey headerKey=new GlobalKey();
  double beforeScroll=0.0;

  @override
  void initState() {
    super.initState();
    headerData=widget.adsorptionDatas.first;
    widget.scrollController.addListener((){
      handlingEvents();
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Container(
      key : headerKey,
      transform: Matrix4.translationValues(0.0, headerOffset, 0.0),
      width: widget.itemWidth,
      child: widget.headChild(headerData),
    );
  }

  void handlingEvents() async{
    double chileGlobalPositionY;
    double chileHeight;
    //headView的高度
    double hearKeyHeight=headerKey.currentContext.findRenderObject().paintBounds.size.height;
    int memoryPosition = widget.viewChangeListener.getMemoryPosition();
    GlobalKey listViewKey = widget.viewChangeListener.getListViewKey();
    //获取ListView在屏幕中的位置
    double listViewGlobalPositionY=listViewKey.currentContext.findRenderObject().getTransformTo(null).getTranslation().y;
    for(int i = memoryPosition;i<=widget.adsorptionDatas.length;i++){
      if(widget.adsorptionDatas[i].adsorptionKey.currentContext==null){
        continue;
      }
      //子控件在屏幕中的位置 用于计算第一个可见Item的位置
      chileGlobalPositionY=widget.adsorptionDatas[i].adsorptionKey.currentContext.findRenderObject().getTransformTo(null).getTranslation().y;
      //控件高度 用于计算第一个可见Item的位置
      chileHeight=widget.adsorptionDatas[i].adsorptionKey.currentContext.findRenderObject().paintBounds.size.height;
      //如果在屏幕中可见
      if(chileGlobalPositionY+chileHeight>listViewGlobalPositionY){
        int a=0;
        //计算header处于完整显示状态的位置
        for(int k=i;k<widget.adsorptionDatas.length;k++){
          if(widget.adsorptionDatas[k].isHeader){
            a=k;
            if(widget.viewChangeListener!=null) {
              widget.viewChangeListener.saveHeaderPosition(
                  k, listViewGlobalPositionY);
            }
            break;
          }
        }

        double currentScrollPosition=widget.scrollController.position.extentBefore;

        //下一个Hear的位置，用于计算是否需要吸顶
        double nextHeaderGlobalPositionY=0.0;
        if(a>=1) {
          var context = widget.adsorptionDatas[a].adsorptionKey.currentContext;
          if(context!=null ) {
            nextHeaderGlobalPositionY=context.findRenderObject().getTransformTo(null).getTranslation().y;
          }
        } else{
          //如果是0  则可能是因为是最后一个hear  后面没有了 所以a=0
          showHoleHeaderView(i);
          break;
        }

        //如果nextHeader滑动到吸顶布局下面  就是说被覆盖  则需要偏移吸顶布局
        if(listViewGlobalPositionY +hearKeyHeight>nextHeaderGlobalPositionY){
          whenHeaderOver(currentScrollPosition,nextHeaderGlobalPositionY,listViewGlobalPositionY,hearKeyHeight,a);
        }else{
          showHoleHeaderView(i);
        }
        break;
      }
    }
  }


  void showHoleHeaderView(int i){
    //始终使header处于完整显示状态
    for(int m=i;m>=0;m--){
      if(widget.adsorptionDatas[m].isHeader) {
        var  headerTitle = widget.adsorptionDatas[m];
        if(headerData!= headerTitle){
          setState(() {
            headerData = headerTitle;
          });
        }
        break;
      }
    }
    if(headerOffset!=0.0) {
      setState(() {
        headerOffset = 0.0;
      });
    }
  }

  void whenHeaderOver(double currentScrollPosition,double nextHeaderGlobalPositionY,double listViewGlobalPositionY,double hearKeyHeight,int a){
    beforeScroll=currentScrollPosition;
    headerOffset = nextHeaderGlobalPositionY - listViewGlobalPositionY - hearKeyHeight;
//    if(headerOffset < -hearKeyHeight){
//      setState(() {
//        headerData=widget.adsorptionDatas[a];
//        headerOffset=0.0;
//      });
//      return;
//    }


    // 改变布局
    if(currentScrollPosition-beforeScroll<0){
      //检测到再向上划就越出当前组 提前改变header的内容并偏移
      for(int i=a-1;i>=0;i--){
        if(widget.adsorptionDatas[i].isHeader){
          var headerTitle = widget.adsorptionDatas[i];
          if(headerData != headerTitle){
            setState(() {
              headerData=headerTitle;
            });
          }
          break;
        }
      }
    }

  }
}


class LifeCycleWidget extends StatefulWidget{

  final Widget child;
  final int index;
  final PositionChangedListener changedListener;

  LifeCycleWidget({
    @required this.child,
    @required this.index,
    @required this.changedListener,
  });

  @override
  State<StatefulWidget> createState() {
    return LifeCycleWidgetState();
  }
}


class LifeCycleWidgetState extends State<LifeCycleWidget>{
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void didChangeDependencies() {
    if(widget.changedListener!=null){
      widget.changedListener.onWidgetInit(widget.index);
    }
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    if(widget.changedListener!=null){
      widget.changedListener.onWidgetDispose(widget.index);
    }
    super.deactivate();
  }
}

abstract class PositionChangedListener{
  void onWidgetDispose(int index);
  void onWidgetInit(int index);
}

abstract class ViewChangeListener{
  void saveHeaderPosition(int k,double listViewGlobalPositionY);
  GlobalKey getListViewKey();
  int getMemoryPosition();
}
