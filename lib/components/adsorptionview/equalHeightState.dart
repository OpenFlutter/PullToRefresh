import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterapp/bin/adsorptiondatabin.dart';
import 'package:flutterapp/components/adsorptionview/adsorptionview.dart';

///此控件适用于固定高度的ListView
class AdsorptionViewState<T extends AdsorptionData> extends State<AdsorptionView<T>>{

  ScrollController scrollController=new ScrollController();

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new AdsorptionListView(
          scrollController: scrollController,
          adsorptionDatas: widget.adsorptionDatas,
          generalItemChild: widget.generalItemChild,
          headChild: widget.headChild,
          itemHeight: widget.itemHeight,
          itemWidth: widget.itemWidth,
          cacheExtent: widget.cacheExtent,
        ),
        new GestureDetector(
          onTap: (){
            double pixels= scrollController.position.pixels;
            int a=pixels~/widget.itemHeight;
            for(int i=a;i>=0;i--){
              if(widget.adsorptionDatas[i].isHeader) {
                scrollController.animateTo(i*widget.itemHeight, duration: new Duration(milliseconds: 200), curve: Curves.linear);
                break;
              }
            }
          },
          child: new HeaderView(
            scrollController: scrollController,
            headChild: widget.headChild,
            adsorptionDatas: widget.adsorptionDatas,
            itemWidth: widget.itemWidth,
            itemHeight: widget.itemHeight,
          ),
        ),
      ],
    );
  }
}


class AdsorptionListView<T extends AdsorptionData> extends StatefulWidget{
  final ScrollController scrollController;
  final double itemHeight;
  final double itemWidth;
  final double cacheExtent;
  final List<T> adsorptionDatas;
  final GetHearWidget<T> headChild;
  final GetGeneralItem<T> generalItemChild;

  AdsorptionListView({
    @required this.adsorptionDatas,
    @required this.headChild,
    @required this.generalItemChild,
    this.itemHeight:50.0,
    this.itemWidth:double.infinity,
    this.cacheExtent:30.0,
    @required this.scrollController,
  }): assert(
  adsorptionDatas!=null,
  generalItemChild!=null&&
      headChild!=null,
  );

  @override
  State<StatefulWidget> createState() {
    return AdsorptionListViewState<T>();
  }
}

class AdsorptionListViewState<T extends AdsorptionData> extends State<AdsorptionListView<T>>{

  ScrollPhysics scrollPhysics=new ClampingScrollPhysics();

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      physics: scrollPhysics,
      cacheExtent: widget.cacheExtent,
      controller: widget.scrollController,
      itemCount: widget.adsorptionDatas.length,
      itemBuilder: (context, index) {
        if(widget.adsorptionDatas[index].isHeader){
          return new Container(
            width: widget.itemWidth,
            height: widget.itemHeight,
            child: widget.headChild(widget.adsorptionDatas[index]),
          );
        }else{
          return new Container(
            width: widget.itemWidth,
            height: widget.itemHeight,
            child: widget.generalItemChild(widget.adsorptionDatas[index]),
          );
        }
      },
    );
  }
}


class HeaderView<T extends AdsorptionData> extends StatefulWidget{

  final ScrollController scrollController;
  final double itemHeight;
  final double itemWidth;
  final GetHearWidget<T> headChild;
  final List<T> adsorptionDatas;

  HeaderView({
    @required this.scrollController,
    this.itemHeight:50.0,
    this.itemWidth:double.infinity,
    @required this.headChild,
    @required this.adsorptionDatas,
  });

  @override
  State<StatefulWidget> createState() {
    return new HeaderViewState<T>();
  }
}

class HeaderViewState<T extends AdsorptionData> extends State<HeaderView<T>>{
  double headerOffset=0.0;
  T headerStr;
  double beforeScroll=0.0;

  @override
  void initState() {
    headerStr=widget.adsorptionDatas.first;

    widget.scrollController.addListener((){
      //计算滑动了多少距离了
      double pixels=widget.scrollController.position.pixels;

      //根据滑动的距离 计算当前可见的第一个Item的Position
      int a=pixels~/widget.itemHeight;
      //计算滑动出屏幕多少距离
      double b=pixels%widget.itemHeight;
      double currentScrollPosition=widget.scrollController.position.extentBefore;
      //如果下一个item是Header 则偏移 如果不是 则偏移量=0
      if(widget.adsorptionDatas[a+1].isHeader){
        setState(() {
          // 改变布局
          if(currentScrollPosition-beforeScroll<0){
            //检测到再向上划就越出当前组 提前改变header的内容并偏移
            for(int i=a;i>=0;i--){
              if(widget.adsorptionDatas[i].isHeader){
                headerStr=widget.adsorptionDatas[i];
                break;
              }
            }
          }
          beforeScroll=currentScrollPosition;
          headerOffset=-b;
        });
      }else{
        //始终使header处于完整显示状态
        for(int i=a;i>=0;i--){
          if(widget.adsorptionDatas[i].isHeader) {
            if(headerStr != widget.adsorptionDatas[i]) {
              setState(() {
                headerStr = widget.adsorptionDatas[i];
              });
            }
            break;
          }
        }
        if(headerOffset!=0){
          setState(() {
            headerOffset=0.0;
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      transform: Matrix4.translationValues(0.0, headerOffset, 0.0),
      width: widget.itemWidth,
      height: widget.itemHeight,
      child: widget.headChild(headerStr),
    );
  }
}